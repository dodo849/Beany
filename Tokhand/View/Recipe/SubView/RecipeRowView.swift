//
//  RecipeRowView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    @AppStorage("selectedRecipeId") var selectedRecipeId: String = UserDefaults.standard.string(
        forKey: UserDefaultConstant.selectedRecipeId
    ) ?? ""
    
    var body: some View {
        let lastStep = recipe.steps
            .last(where: { $0.order == recipe.steps.count - 1 }) ?? Step()
        VStack {
            Spacer().frame(minHeight: 20)
            HStack {
                if !recipe.name.isEmpty {
                    Text("\(recipe.name)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                Group {
                    Text("\(recipe.author.description)")
                    Text("소요시간 \(TimeFormatHelper.secondsToTimeString(lastStep.accumulatedSeconds ?? 0))")
                    Text("추출양 \(lastStep.accumulatedWater ?? 0)ml")
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(.gray.opacity(0.2))
                .cornerRadius(5)
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
                ForEach(
                    Array(recipe.steps.sorted(by: {$0.order < $1.order}).enumerated()),
                    id: \.element.id) { index, step in
                        VStack(spacing: 4) {
                            Text("\(step.seconds)초")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Text("\(step.water)ml")
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
            .overlay {
                isSelectedRecipe()
                ? RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                : nil
            }
            .cornerRadius(20)
        }
    }
    
    func isSelectedRecipe() -> Bool {
        return selectedRecipeId == recipe.id.uuidString
    }
}

#Preview {
    RecipeRowView(recipe: sampleRecipe)
}
