//
//  RecipeRowView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import StackCoordinator

struct RecipeRowView: View {
    let recipe: Recipe
    
    @Environment(\.modelContext) var context
    @AppStorage("selectedRecipeId") 
    var selectedRecipeId: String = UserDefaultsRepository.get(
        forKey: .selectedRecipeId,
        ""
    )

    var coordinator: BaseCoordinator<RecipeLink> = BaseCoordinator<RecipeLink>()
    
    @State var dragOffset: CGFloat = 0
    private let dragStopOffset: CGFloat = 65
    
    var body: some View {
        let lastStep = recipe.steps
            .last(where: { $0.order == recipe.steps.count - 1 }) ?? Step()
        VStack(spacing: 7) {
            VStack {
                Spacer().frame(minHeight: 15)
                if !recipe.name.isEmpty {
                    HStack {
                        Text("\(recipe.name)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                }
                
                HStack {
                    Group {
                        Text("\(recipe.author.description)")
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(5)
                        Text("소요시간 \(TimeFormatHelper.secondsToTimeString(lastStep.accumulatedSeconds ?? 0))")
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .background(.coffee.opacity(0.1))
                            .cornerRadius(5)
                        Text("추출량 \(lastStep.accumulatedWater ?? 0)ml")
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(5)
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .cornerRadius(5)
                    Spacer()
                }
            }
            .padding(.horizontal, PAGE_PADDING)
            
            ZStack {
                HStack {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .padding(.leading, 20 + PAGE_PADDING)
                        .foregroundColor(.strongCoffee)
                        .onTapGesture {
                            coordinator.push(.recipeAddView(recipe))
                        }
                    Spacer()
                    Image(systemName: "minus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 20 + PAGE_PADDING)
                        .foregroundColor(.red)
                        .onTapGesture {
                            AlertHelper.showAlert(
                                title: "삭제하시겠습니까?",
                                message: "삭제후엔 되돌릴 수 없습니다",
                                action: UIAlertAction(title: "예", style: .default) { _ in
                                    if isSelectedRecipe() {
                                        setSelectedRecipeByDefault()
                                    }
                                    context.delete(recipe)
                                })
                        }
                }
                HStack(spacing: 10) {
                    VStack {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
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
                .padding(.horizontal, PAGE_PADDING)
                .offset(x: dragOffset, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if recipe.author != .admin {
                                dragOffset = gesture.translation.width
                            }
                        }
                        .onEnded { gesture in
                            if recipe.author != .admin {
                                if gesture.translation.width < -dragStopOffset {
                                    dragOffset = -dragStopOffset
                                } else if gesture.translation.width > dragStopOffset {
                                    dragOffset = dragStopOffset
                                } else {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .animation(.bouncy(duration: 0.5), value: dragOffset)
            }
        }
        .onAppear {
            dragOffset = 0
        }
    }
    
    func isSelectedRecipe() -> Bool {
        return selectedRecipeId == recipe.id.uuidString
    }
    
    @MainActor func setSelectedRecipeByDefault() {
        UserDefaultsRepository.save(
            FirstInstallAction.shared.defaultRecipeId.uuidString,
            forKey: .selectedRecipeId
        )
    }
}

#Preview {
    RecipeRowView(recipe: sampleRecipe)
}
