//
//  TimerReducer.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import Foundation
import SwiftData
import AVFoundation

import ComposableArchitecture

@MainActor
@Reducer
struct TimerReducer {
    enum TimerState {
        case ready
        case active
        case paused
        case complete
        
        mutating func toggle() {
            switch self {
            case .ready:
                self = .active
            case .active:
                self = .paused
            case .paused:
                self = .active
            case .complete:
                self = .ready
            }
        }
    }
    
    @ObservableState
    struct State: Equatable {
        var timerState: TimerState = .ready
        var secondsElapsed: Int = 0
        var totalSeconds: Int = 1
        var totalWater: Int = 1
        var recipe: Recipe = .init()
        var currentStep: Step = .init()
    }
    
    enum Action {
        // for view
        case onAppear
        case startTimer
        case pauseTimer
        case resetTimer
        case timerTicked
        
        // for reducer
        case changeRecipe(selectedId: UUID)
        case proceedToNextStep
        case timerCompleted
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.timerCompleteSoundHelper) var timerCompleteSoundHelper
    private enum CancelID { case timer }
    private var context = sharedModelContainer.mainContext
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard let selectedRecipeIdString: String = UserDefaultsRepository.get(
                    forKey: .selectedRecipeId,
                    ""
                )
                else { return Effect<Action>.none }
                
                guard let selectedRecipeId = UUID(uuidString: selectedRecipeIdString)
                else { return Effect<Action>.none }
                
                if state.recipe.id != selectedRecipeId {
                    return .send(.changeRecipe(selectedId: selectedRecipeId))
                }
                
                return .none
                
            case .startTimer:
                SoundSettingDecorator(TimerToggleSoundHelper()).play()
                
                state.timerState.toggle()
                return .run { [isTimerActive = state.timerState == .active] send in
                    guard isTimerActive else { return }
                    for await _ in await self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked, animation: .default)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .pauseTimer:
                state.timerState = .paused
                return .none
                
            case .resetTimer:
                state.secondsElapsed = 0
                state.currentStep = state.recipe.steps
                    .first(where: { $0.order == 0 }) ?? Step()
                state.timerState = .ready
                return .cancel(id: CancelID.timer)
                
            case .timerTicked:
                state.secondsElapsed += 1
                
                let isAllStepCompleted = state.secondsElapsed >= state.totalSeconds
                if isAllStepCompleted {
                    return .send(.timerCompleted)
                }
                
                let isCurrentStepCompleted = state.secondsElapsed >= state.currentStep.accumulatedSeconds ?? 0
                if isCurrentStepCompleted {
                    return .send(.proceedToNextStep)
                }
                return .none
                
            case .changeRecipe(let selectedRecipeId):
                let fetchPredicate = FetchDescriptor<Recipe>(
                    predicate: Recipe.findByIdPredicate(selectedRecipeId)
                )
                guard let selectedRecipe = try? context.fetch(fetchPredicate).first
                else { return Effect<Action>.none }
                
                state.recipe = selectedRecipe
                state.currentStep = selectedRecipe.steps
                    .first(where: { $0.order == 0 }) ?? Step()
                let lastStep = state.recipe.steps
                    .last(where: { $0.order == state.recipe.steps.count - 1 }) ?? Step()
                state.totalSeconds = lastStep.accumulatedSeconds ?? 0
                state.totalWater = lastStep.accumulatedWater ?? 0
                return .none
                
            case .proceedToNextStep:
                SoundSettingDecorator(NextStepSoundHelper()).play()
                
                let currentOrder = state.currentStep.order
                if currentOrder < state.recipe.steps.count - 1,
                   let nextStep = state.recipe.steps.first(
                    where: { $0.order == currentOrder + 1 }
                   ) {
                    state.currentStep = nextStep
                }
                return .none
                
            case .timerCompleted:
                timerCompleteSoundHelper.play()
//                SoundHelperDecorator(TimerCompleteSoundHelper()).play()
                
                state.timerState = .complete
                return .cancel(id: CancelID.timer)
            }
        }
    }
}
