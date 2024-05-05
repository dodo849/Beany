//
//  TimerReducer.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import Foundation
import ComposableArchitecture

struct Stage: Equatable {
    var order: Int
    var name: String
    var description: String
    var seconds: Int
    var accumulatedSeconds: Int
    var waterQuantity: Int
    var accumulatedWaterQuantity: Int
}

var stages: [Stage] = [
    .init(order: 0, name: "뜸들이기", description: "원두를 충분히 적셔주세요", seconds: 20, accumulatedSeconds: 20, waterQuantity: 40, accumulatedWaterQuantity: 40),
    .init(order: 1, name: "첫번째 추출", description: "가운데부터 균일한 속도로 물을 부어주세요", seconds: 30, accumulatedSeconds: 50, waterQuantity: 40, accumulatedWaterQuantity: 80),
    .init(order: 2, name: "두번째 추출", description: "속도를 조금 높여 물을 부어주세요", seconds: 30, accumulatedSeconds: 80, waterQuantity: 40, accumulatedWaterQuantity: 120),
        .init(order: 3, name: "세번째 추출", description: "시간이 되면 드리퍼 내에 물이 남아있어도 추출을 마무리해주세요", seconds: 30, accumulatedSeconds: 110, waterQuantity: 40, accumulatedWaterQuantity: 160),
]

@Reducer
struct TimerReducer {
    @ObservableState
    struct State: Equatable {
        var isTimerActive = false
        var secondsElapsed = 0
        var currentStage: Stage = stages[0]
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
                state.isTimerActive.toggle()
                return .run { [isTimerActive = state.isTimerActive] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked, animation: .default)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .stopTimer:
                return .cancel(id: CancelID.timer)
                
            case .timerTicked:
                state.secondsElapsed += 1
                if state.secondsElapsed >= stages.last!.accumulatedSeconds {
                    return .send(.stopTimer)
                }
                if state.secondsElapsed > state.currentStage.accumulatedSeconds {
                    state.currentStage = stages[state.currentStage.order + 1]
                }
                return .none
                
            case .pauseTimer:
                state.isTimerActive = false
                return .none
            }
        }
    }
}

