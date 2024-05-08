//
//  RecipeAddBuilder.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/8/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator

struct RecipeAddBuilder: BuilderProtocol {
    
    var coordinator = BaseCoordinator<RecipeAddLink>()
    
    var recipeInputModel: RecipeAddView.RecipeInputModel
    
    init(recipe: Recipe? = nil) {
        if let recipe = recipe {
            self.recipeInputModel = RecipeAddView.RecipeInputModel(
                id: recipe.id,
                name: recipe.name,
                steps: recipe.steps.sorted(by: {$0.order < $1.order}).map {
                    return RecipeAddView.StepInputModel(
                        name: $0.name,
                        seconds: String($0.seconds),
                        water: String($0.water),
                        helpText: $0.helpText
                    )
                }
            )
        } else {
            self.recipeInputModel = .init()
        }
    }
    
    var body: some View {
        BaseBuilder(coordinator: coordinator) {
            RecipeAddView(recipe: recipeInputModel)
        }
    }
}

