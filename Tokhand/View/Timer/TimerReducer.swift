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
    @ObservableState
    struct State: Equatable {
        var isTimerActive = false
        var secondsElapsed = 0
        var recipe: Recipe = .init()
        var currentStep: Step = .init()
    }
    
    enum Action {
        case onAppear
        case startTimer
        case stopTimer
        case pauseTimer
        case timerTicked
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    private var context = sharedModelContainer.mainContext
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard let selectedRecipeIdString = UserDefaults.standard.string(forKey: UserDefaultConstant.selectedRecipeId)
                else { return Effect<Action>.none }
                guard let selectedRecipeId = UUID(uuidString: selectedRecipeIdString)
                else { return Effect<Action>.none }
                
                let fetchPredicate = FetchDescriptor<Recipe>(
                    predicate: #Predicate<Recipe> { $0.id == selectedRecipeId }
                )
                guard let selectedRecipe = try? context.fetch(fetchPredicate).first
                else { return Effect<Action>.none }
                        
                state.recipe = selectedRecipe
                state.currentStep = selectedRecipe.steps.first ?? Step()
                return .none
                        
            case .startTimer:
                AudioServicesPlaySystemSound(1105)
                state.isTimerActive.toggle()
                return .run { [isTimerActive = state.isTimerActive] send in
                    guard isTimerActive else { return }
                    for await _ in await self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked, animation: .default)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .stopTimer:
                state.secondsElapsed = 0
                state.currentStep = sampleSteps[0]
                return .cancel(id: CancelID.timer)
                
            case .timerTicked:
                state.secondsElapsed += 1
                
                guard let accumulatedSeconds = sampleSteps.last!.accumulatedSeconds
                else { return .none }
                
                if state.secondsElapsed >= accumulatedSeconds {
                    return .send(.stopTimer)
                }
                if state.secondsElapsed > accumulatedSeconds {
                    if let index = sampleSteps
                        .firstIndex(of: state.currentStep)
                        , index < state.recipe.steps.count - 1 {
                        state.currentStep = sampleSteps[index + 1]
                    }
                    
                }
                return .none
                
            case .pauseTimer:
                state.isTimerActive = false
                return .none
            }
        }
    }
}

