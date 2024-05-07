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
    case recipeAddView
    
    func matchView() -> any View {
        switch self {
        case .recipeAddView:
            return RecipeAddView()
        }
    }
}
