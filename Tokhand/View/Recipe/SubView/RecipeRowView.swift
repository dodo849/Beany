//
//  RecipeRowView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Spacer().frame(minHeight: 20)
            HStack {
                Text("\(recipe.name)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
            }
            HStack(spacing: 10) {
                VStack() {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                    Image(systemName: "drop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .frame(maxWidth: 15)
                }
                ForEach(Array(recipe.steps.enumerated()), id: \.element.id) { index, step in
                    VStack(spacing: 4) {
                        Text("\(step.seconds)초")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("\(step.water)ml")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    if index != recipe.steps.count - 1 {
                        Text(":")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.horizontal, 10)
            .background(.white)
            .cornerRadius(20)
        }
    }
}
