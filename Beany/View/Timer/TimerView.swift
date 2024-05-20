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
    let TOP_BAR_HEIGHT = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    let TOP_TEXT_COLOR_CHANGE_PERCENTAGE: CGFloat = 85
    let MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE: CGFloat = 48
    let BOTTOM_TEXT_COLOR_CHANGE_PERCENTAGE: CGFloat = 10
    
    var coordinator: BaseCoordinator<TimerLink>
    
    @Bindable var store: StoreOf<TimerReducer>
    var currentWater: CGFloat {
        let currentWaterSpeed = CGFloat(store.currentStep.water) / CGFloat(store.currentStep.seconds)
        let currentSecondElapsed = CGFloat(store.secondsElapsed + store.currentStep.seconds - (store.currentStep.accumulatedSeconds ?? 0))
        let previousAccumulatedWater = CGFloat(store.currentStep.accumulatedWater ?? 0) - CGFloat( store.currentStep.water)
        return currentWaterSpeed * (currentSecondElapsed) + previousAccumulatedWater
    }
    var waterHeightOffset: CGFloat {
        return UIScreen.main.bounds.size.height * 1.5 - UIScreen.main.bounds.size.height * (currentWater / CGFloat(store.totalWater))
    }
    var waterPercentage: CGFloat {
        return currentWater / CGFloat(store.totalWater) * 100.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            Group {
                WaveView(waveOffset: store.secondsElapsed)
                    .position(x: UIScreen.main.bounds.size.width/2, y: waterHeightOffset)
                    .frame(maxWidth: .infinity)
                    .animation(.linear(duration: 1), value: store.secondsElapsed)
                MeasurementView(max: store.totalWater)
                VStack(spacing: 7) {
                    Spacer().frame(height: TOP_BAR_HEIGHT)
                    Spacer()
                        .frame(height: 30)
                    Text(store.currentStep.name)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            waterPercentage > TOP_TEXT_COLOR_CHANGE_PERCENTAGE + 3 ? .white : .strongCoffee
                        )
                    Text(store.currentStep.helpText)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(
                            waterPercentage > TOP_TEXT_COLOR_CHANGE_PERCENTAGE ? .white : .strongCoffee
                        )
                    
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
                    .foregroundStyle(
                        waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE + 5 ? .white : .strongCoffee
                    )
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Text("\(TimeFormatHelper.secondsToTimeString(store.secondsElapsed))")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE ? .white : .strongCoffee
                        )
                        .animation(.interactiveSpring(duration: 1), value: waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE)
                        .animation(.none, value: store.secondsElapsed)
                    
                    Text("\(TimeFormatHelper.secondsToTimeString(store.currentStep.accumulatedSeconds ?? 0)) 까지")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(
                            waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE - 8 ? .white : .strongCoffee
                        )
                    
                    Spacer()
                    
                    Text("총 \(store.currentStep.accumulatedWater ?? 0)ml 추출 중")
                        .foregroundStyle(waterPercentage > BOTTOM_TEXT_COLOR_CHANGE_PERCENTAGE ? .white : .strongCoffee)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.coffee.opacity(0.1))
                
            }
            .blur(radius: store.timerState == .active ? 0 : 15)
            .animation(.interpolatingSpring, value: store.timerState)
            
            if store.timerState != .active {
                ZStack {
                    VStack {
                        Spacer().frame(height: TOP_BAR_HEIGHT)
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
                        .foregroundColor(waterPercentage > TOP_TEXT_COLOR_CHANGE_PERCENTAGE ? .white : .strongCoffee)
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
//                            .blendMode(.plusDarker)
                            .foregroundStyle(
                                waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE ? .white : .strongCoffee
                            )
                        if store.timerState != .ready {
                            Button(action: { store.send(.resetTimer) }) {
                                Image(systemName: "arrow.clockwise")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .foregroundColor(waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE ? .strongCoffee : .white)
                            .background(waterPercentage > MIDDLE_TEXT_COLOR_CHANGE_PERCENTAGE ? .white.opacity(0.6) : .strongCoffee.opacity(0.8))
                            .cornerRadius(100)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
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
