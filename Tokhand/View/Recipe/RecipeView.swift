//
//  RecipeView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI
import SwiftData

import StackCoordinator

struct RecipeView: View {
    
    var coordinator: BaseCoordinator<RecipeLink>
    
    @Query(sort: \Recipe.createdAt)
    private var recipes: [Recipe]
    
    var body: some View {
        ScrollView {
            VStack {
                RecipeTitleView(plusAction: {
                    coordinator.push(.recipeAddView)
                })
                .padding([.top, .horizontal], PAGE_PADDING)
                ForEach(recipes) { recipe in
                    RecipeRowView(recipe: recipe)
                        .onTapGesture {
                            UserDefaults.standard.setValue(
                                recipe.id.uuidString,
                                forKey: UserDefaultConstant.selectedRecipeId
                            )
                        }
                }
            }
        }
//        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.strongCoffee)
        .background(.coffee.opacity(0.1))
        .customBackButton {
            coordinator.path.removeLast()
        }
    }
    
}

#Preview {
    RecipeView(coordinator: BaseCoordinator<RecipeLink>())
}
