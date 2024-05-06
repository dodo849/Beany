//
//  RecipeLink.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator

enum RecipeLink: LinkProtocol {
    case recipeAddView(_ coordinator: BaseCoordinator<RecipeLink>)
    
    func matchView() -> any View {
        switch self {
        case .recipeAddView(let coordinator):
            return RecipeAddView(
                coordinator:coordinator
            )
        }
    }
}
