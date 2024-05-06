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
    
    @Query(sort: \Recipe.steps.order) private var recipes: [Recipe]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("레시피")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            coordinator.push(.recipeAddView(coordinator))
                        }
                }
                ForEach(recipes) {
                    RecipeRowView(recipe: $0)
                }
            }
        }
        .padding()
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
