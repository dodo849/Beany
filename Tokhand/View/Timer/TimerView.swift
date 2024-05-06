//
//  TimerView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import SwiftUI
import Combine

import ComposableArchitecture
import StackCoordinator

struct TimerView: View {
    let WAVE_CIRCLE_SIZE: CGFloat = 400
    
    var coordinator: BaseCoordinator<TimerLink>
    
    @Bindable var store: StoreOf<TimerReducer>
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                WaveView(waveOffset: store.secondsElapsed)
                    .frame(maxWidth: .infinity)
                    .offset(x: 0, y: geometry.size.height - geometry.size.height * CGFloat(store.secondsElapsed) / 100)
                    .animation(.bouncy, value: store.secondsElapsed)
                
                VStack(spacing: 7) {
                    Spacer()
                        .frame(height: 30)
                    Text(store.currentStep.name)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                    Text(store.currentStep.helpText)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                    HStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(store.currentStep.water)ml")
                        Spacer()
                            .frame(maxWidth: 15)
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(store.currentStep.seconds)초")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text("\(store.secondsElapsed)초")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Text("\(store.currentStep.accumulatedSeconds ?? 0)초 까지")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Spacer()
                    Text("현재까지 \(store.currentStep.accumulatedWater ?? 0)ml 추출")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                        .frame(height: 30)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.strongCoffee)
                //                .blendMode(.exclusion)
                
            }
            .background(.coffee.opacity(0.1))
            .blur(radius: store.isTimerActive ? 0 : 15)
            .animation(.interpolatingSpring, value: store.isTimerActive)
            
            if !store.isTimerActive {
                ZStack {
                    VStack {
                        HStack(spacing: 15){
                            Spacer()
                            Image(systemName: "cup.and.saucer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    coordinator.push(.recipeView)
                                }
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        Text("탭하면 시작합니다")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .blendMode(.plusDarker)
                        Button(action: { store.send(.stopTimer) }) {
                            Text("리셋")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .foregroundColor(.white)
                        .background(.strongCoffee)
                        .cornerRadius(100)
                        Spacer()
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.strongCoffee)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: store.isTimerActive)
            }
            
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
            coordinator: BaseCoordinator<TimerLink>(),
            store: Store(initialState: TimerReducer.State()) {
                TimerReducer()
            }
        )
    }
}
