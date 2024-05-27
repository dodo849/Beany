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
    case recipeAddView(_ recipe: Recipe? = nil)
    
    func matchView() -> any View {
        switch self {
        case .recipeAddView(let recipe):
            return RecipeAddBuilder(recipe: recipe)
        }
    }
}
