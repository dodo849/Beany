//
//  TimerReducer.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import Foundation
import ComposableArchitecture
import AVFoundation

@Reducer
struct TimerReducer {
    @ObservableState
    struct State: Equatable {
        var isTimerActive = false
        var secondsElapsed = 0
        var currentStep: Step = sampleSteps[0]
    }
    
    enum Action {
        case startTimer
        case stopTimer
        case pauseTimer
        case timerTicked
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                AudioServicesPlaySystemSound(1105)
                state.isTimerActive.toggle()
                return .run { [isTimerActive = state.isTimerActive] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(1)) {
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
                    if let index = sampleSteps.firstIndex(of: state.currentStep), index < sampleSteps.count - 1 {
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

