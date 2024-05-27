//
//  TimerBuilder.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator

struct TimerBuilder: BuilderProtocol {
    
    var coordinator = BaseCoordinator<TimerLink>()
    
    var body: some View {
        BaseBuilder(coordinator: coordinator) {
            TimerView(
                coordinator: coordinator,
                store: Store(initialState: TimerReducer.State()) {
                    TimerReducer()
                }
            )
        }
    }
}
