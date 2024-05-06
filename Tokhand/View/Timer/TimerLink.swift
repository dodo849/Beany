//
//  TimerLink.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import StackCoordinator

enum TimerLink: LinkProtocol {
    case recipeView
    
    func matchView() -> any View {
        switch self {
        case .recipeView:
            return RecipeBuilder()
        }
    }
}
