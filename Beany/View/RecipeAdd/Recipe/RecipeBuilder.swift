//
//  RecipeBuilder.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator

struct RecipeBuilder: BuilderProtocol {
    
    var coordinator = BaseCoordinator<RecipeLink>()
    
    var body: some View {
        BaseBuilder(coordinator: coordinator) {
            RecipeView(
                coordinator: coordinator
            )
        }
    }
}

