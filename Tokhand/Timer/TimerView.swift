//
//  TimerView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import SwiftUI
import Combine
import ComposableArchitecture


struct TimerView: View {
    let WAVE_CIRCLE_SIZE: CGFloat = 400
    
    var store: StoreOf<TimerReducer>
    
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                ZStack(alignment: .center){
                    
                    RoundedRectangle(cornerRadius: geometry.size.width * 4 / 2.3)
                        .fill(Color.coffee.opacity(0.7))
                        .frame(
                            width: geometry.size.width * 4,
                            height: geometry.size.width * 4
                        )
                        .rotationEffect(
                            .degrees(Double(-store.secondsElapsed % 360 * 20))
                        )
                        .offset(x: -geometry.size.width * 1.5, y: 0)
                        .animation(.linear(duration: 1), value: store.secondsElapsed)
                    
                    RoundedRectangle(cornerRadius: geometry.size.width * 4 / 2.2)
                        .fill(Color.coffee.opacity(0.7))
                        .frame(
                            width: geometry.size.width * 4,
                            height: geometry.size.width * 4
                        )
                        .rotationEffect(
                            .degrees(Double(store.secondsElapsed % 360 * 30))
                        )
                        .offset(x: -geometry.size.width * 1.5, y: 0)
                        .animation(.linear(duration: 1), value: store.secondsElapsed)
                    
                    RoundedRectangle(cornerRadius: geometry.size.width * 4 / 2.2)
                        .fill(Color.coffee.opacity(0.7))
                        .frame(
                            width: geometry.size.width * 4,
                            height: geometry.size.width * 4
                        )
                        .rotationEffect(
                            .degrees(Double(-store.secondsElapsed % 360 * 20 + 20))
                        )
                        .offset(x: -geometry.size.width * 1.5, y: 0)
                        .animation(.linear(duration: 1), value: store.secondsElapsed)
                    Rectangle()
                        .offset(x: 0, y: 30)
                        .fill(Color.coffee)
                }
                .frame(maxWidth: .infinity)
                .offset(x: 0, y: geometry.size.height - CGFloat(store.secondsElapsed) * 10)
                .animation(.bouncy, value: store.secondsElapsed)
                VStack(spacing: 7) {
                    Spacer()
                        .frame(height: 30)
                    Text(store.currentStage.name)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                    Text(store.currentStage.description)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                    HStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(store.currentStage.waterQuantity)ml")
                        Spacer()
                            .frame(maxWidth: 15)
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(store.currentStage.seconds)초")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text("\(store.secondsElapsed)초")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Text("\(store.currentStage.accumulatedSeconds)초 까지")
                        .foregroundColor(.coffee)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Spacer()
                    Text("현재까지 \(store.currentStage.accumulatedWaterQuantity)ml 추출")
                        .foregroundColor(.white)
                        .blendMode(.normal)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                        .frame(height: 30)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blendMode(.plusDarker)
                .foregroundColor(.coffee)
            }
            .background(.coffee.opacity(0.1))
            .blur(radius: store.isTimerActive ? 0 : 15)
            .animation(.interpolatingSpring, value: store.isTimerActive)
            
            VStack(alignment: .center) {
                if !store.isTimerActive {
                    Spacer()
                    Text("탭하면 시작합니다")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.coffee)
                        .animation(.none, value: store.isTimerActive)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .animation(.interpolatingSpring, value: store.isTimerActive)
            
        }
        .onTapGesture {
            store.send(.startTimer)
        }
        .onDisappear() {
            store.send(.stopTimer)
        }
        
        
    }
    
}

#Preview {
    NavigationStack {
        TimerView(
            store: Store(initialState: TimerReducer.State()) {
                TimerReducer()
            }
        )
    }
}
