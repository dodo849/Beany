//
//  SettingBuilder.swift
//  Beany
//
//  Created by DOYEON LEE on 5/27/24.
//

import Foundation
import SwiftUI

import StackCoordinator

struct SettingBuilder: BuilderProtocol {
    
    var coordinator = BaseCoordinator<SettingLink>()
    
    var body: some View {
        BaseBuilder(coordinator: coordinator) {
            SettingView(
                coordinator: coordinator
            )
        }
    }
}
