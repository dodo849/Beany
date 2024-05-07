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
        case onAppear
        case startTimer
        case pauseTimer
        case resetTimer
        case timerTicked
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    private var context = sharedModelContainer.mainContext
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard let selectedRecipeIdString = UserDefaults.standard.string(
                    forKey: UserDefaultConstant.selectedRecipeId
                )else { return Effect<Action>.none }
                guard let selectedRecipeId = UUID(uuidString: selectedRecipeIdString)
                else { return Effect<Action>.none }
                
                let fetchPredicate = FetchDescriptor<Recipe>(
                    predicate: Recipe.findByIdPredicate(selectedRecipeId)
                )
                guard let selectedRecipe = try? context.fetch(fetchPredicate).first
                else { return Effect<Action>.none }
                // BUG: 문제점 발견.. @Model 인스턴스를 직접 만들어서 접근하려고 하면 nested model 접근에 crash가 남. 즉, context에서 fetch한 그대로의 인스턴스를 사용해야함...ㄷㄷ
                // 예상 1: 새로 생성한 Recipe는 context 객체가 아닌데 정렬해서 저장한 steps는 context 객체라서 오류가 났다.
                // 예상 2. 그냥 직접 만들어서 생성하는 것 자체가 안된다. (초기화는 가능, 접근은 불가능))
                
                state.recipe = selectedRecipe
                state.currentStep = selectedRecipe.steps
                    .first(where: { $0.order == 0 }) ?? Step()
                let lastStep = state.recipe.steps
                    .last(where: { $0.order == state.recipe.steps.count - 1 }) ?? Step()
                state.totalSeconds = lastStep.accumulatedSeconds ?? 0
                state.totalWater = lastStep.accumulatedWater ?? 0
                return .none
                
            case .startTimer:
                AudioServicesPlaySystemSound(1105)
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
                
                // check the timer is completed
                if state.secondsElapsed >= state.totalSeconds {
                    state.timerState = .complete
                    return .cancel(id: CancelID.timer)
                }
                
                // cheack the current step is completed
                if let currentAccumulatedSeconds = state.currentStep.accumulatedSeconds,
                   state.secondsElapsed > currentAccumulatedSeconds {
                    let currentOrder = state.currentStep.order
                    if currentOrder < state.recipe.steps.count - 1,
                       let nextStep = state.recipe.steps.first(
                        where: { $0.order == currentOrder + 1 }
                       ) {
                        state.currentStep = nextStep
                    }
                }
                return .none
            }
        }
    }
}

