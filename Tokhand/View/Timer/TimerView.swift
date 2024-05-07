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
    let topBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    let bottomBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    
    var coordinator: BaseCoordinator<TimerLink>
    
    @Bindable var store: StoreOf<TimerReducer>
    
    var body: some View {
        GeometryReader { geometry in
            let currentWaterSpeed = CGFloat(store.currentStep.water) / CGFloat(store.currentStep.seconds)
            let currentSecondElapsed = CGFloat(store.secondsElapsed + store.currentStep.seconds - (store.currentStep.accumulatedSeconds ?? 0))
            let previousAccumulatedWater = CGFloat(store.currentStep.accumulatedWater ?? 0) - CGFloat( store.currentStep.water)
            let currentWater = currentWaterSpeed * (currentSecondElapsed) + previousAccumulatedWater
            let waterHeight = UIScreen.main.bounds.size.height * 1.5 - UIScreen.main.bounds.size.height * (currentWater / CGFloat(store.totalWater))
            Group {
                WaveView(waveOffset: store.secondsElapsed)
                    .position(x: UIScreen.main.bounds.size.width/2, y: waterHeight)
                    .frame(maxWidth: .infinity)
                    .animation(.linear(duration: 1), value: store.secondsElapsed)
                MeasurementView(max: store.totalWater)
                VStack(spacing: 7) {
                    Spacer().frame(height: topBarHeight)
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
                        Text("\(TimeFormatHelper.secondsToTimeString(store.currentStep.seconds))")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text("\(TimeFormatHelper.secondsToTimeString(store.secondsElapsed))")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Text("\(TimeFormatHelper.secondsToTimeString(store.currentStep.accumulatedSeconds ?? 0)) 까지")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .animation(.none, value: store.secondsElapsed)
                    Spacer()
                    Text("총 \(store.currentStep.accumulatedWater ?? 0)ml 추출 중")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.strongCoffee)
                .background(.coffee.opacity(0.1))
//                .blendMode(.exclusion)
                
            }
            .blur(radius: store.timerState == .active ? 0 : 15)
            .animation(.interpolatingSpring, value: store.timerState)
            
            if store.timerState != .active {
                ZStack {
                    VStack {
                        Spacer().frame(height: topBarHeight)
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
                                .onTapGesture {
                                    coordinator.push(.settingView)
                                }
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        let timerText = {
                            switch (store.timerState) {
                            case .ready:
                                return "탭하면 시작합니다"
                            case .paused:
                                return "탭하면 재개합니다"
                            case .complete:
                                return "추출이 완료되었습니다. \n맛있게 드세요!"
                            case .active:
                                return ""
                            }
                        }()
                        Text(timerText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .blendMode(.plusDarker)
                        if store.timerState != .ready {
                            Button(action: { store.send(.resetTimer) }) {
                                Image(systemName: "arrow.clockwise")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .foregroundColor(.white)
                            .background(.strongCoffee)
                            .cornerRadius(100)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.strongCoffee)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: store.timerState)
            }
            
        }
        .ignoresSafeArea()
        .onTapGesture {
            if store.timerState == .complete {
                
            } else {
                store.send(.startTimer)
            }
        }
        .onAppear() {
            store.send(.onAppear)
        }
        .onDisappear() {
            store.send(.resetTimer)
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
