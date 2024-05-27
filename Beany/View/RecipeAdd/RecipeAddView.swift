//
//  RecipeAddView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture
import StackCoordinator

@MainActor
struct RecipeAddView: View {
    struct RecipeInputModel: Equatable {
        var id: UUID?
        var name: String = ""
        var steps: [StepInputModel] = [.init()]
    }
    
    struct StepInputModel: Equatable {
        var name: String = ""
        var seconds: String = "1"
        var water: String = "1"
        var helpText: String = ""
    }
    
    // MARK: Dependencies
    @Environment(\.modelContext) var context
    var coordinator: BaseCoordinator<RecipeLink> = BaseCoordinator<RecipeLink>()
    
    // MARK: State
    @State var recipe: RecipeInputModel
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "cup.and.saucer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 20)
                        Text("레시피 이름")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                    TextField("레시피를 구분할 이름을 작성해주세요(선택)", text: $recipe.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                
                Divider().padding(.vertical, 10)
                
                Text("추출 단계")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                VStack {
                    ForEach($recipe.steps.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                TextField("순서 혹은 단계 이름을 입력해주세요(선택)", text: $recipe.steps[index].name)
                            }
                            Spacer()
                            HStack(alignment: .center) {
                                ZStack {
                                    HStack {
                                        Image(systemName: "clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 14, height: 14)
                                        TextField("시간", text: Binding(
                                            get: { self.recipe.steps[index].seconds },
                                            set: { newValue in
                                                if let value = Int(newValue), value < 1 {
                                                    self.recipe.steps[index].seconds = "1"
                                                } else {
                                                    self.recipe.steps[index].seconds = newValue
                                                }
                                            }
                                        ))
                                        .keyboardType(.numberPad)
                                        Text("초")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                    }
                                }
                                
                                Divider()
                                Image(systemName: "drop")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .frame(maxWidth: 15)
                                TextField("물 양", text: Binding(
                                    get: { self.recipe.steps[index].water },
                                    set: { newValue in
                                        if let value = Int(newValue), value < 1 {
                                            self.recipe.steps[index].water = "1"
                                        } else {
                                            self.recipe.steps[index].water = newValue
                                        }
                                    }
                                ))
                                .keyboardType(.numberPad)
                                Text("ml")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            HStack {
                                Image(systemName: "doc")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                TextField(
                                    "추출 시 참고할 도움말을 작성해주세요(선택)",
                                    text: $recipe.steps[index].helpText
                                )
                            }
                            HStack {
                                Button(action: { addStep(index) }) {
                                    Text("추가 하기")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .animation(.none, value: recipe.steps)
                                }
                                .padding(.vertical, 7)
                                .padding(.horizontal, 15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                )
                                .foregroundColor(.gray)
                                
                                if index != 0 {
                                    Button(action: { removeStep(index) }) {
                                        Text("삭제 하기")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .animation(.none, value: recipe.steps)
                                    }
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(style: StrokeStyle(lineWidth: 1))
                                    )
                                    .foregroundColor(.gray)
                                }
                                
                            }
                        }
                        .padding()
                        .background(.coffee.opacity(0.1))
                        .cornerRadius(15)
                    }
                }
            }
        }
        .padding(.horizontal, PAGE_PADDING)
        .frame(maxWidth: .infinity)
        .foregroundColor(.strongCoffee)
        .scrollIndicators(.hidden)
        .addHideKeyboardGuesture()
        .customBackButton {
            coordinator.path.removeLast()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveRecipe) {
                    Text("저장")
                        .foregroundColor(.strongCoffee)
                }
            }
        }
        .toolbarBackground(Color.white, for: .navigationBar)
    }
    
    func addStep(_ index: Int) {
        recipe.steps.insert(.init(), at: index + 1)
    }
    
    func removeStep(_ index: Int) {
        recipe.steps.remove(at: index)
    }
    
    func saveRecipe() {
        coordinator.path.removeLast()
        if let recipeId = recipe.id {
            let fetchPredicate = FetchDescriptor<Recipe>(
                predicate: Recipe.findByIdPredicate(recipeId)
            )
            guard let exsistRecipe = try? context.fetch(fetchPredicate).first
            else { return }
            
            exsistRecipe.name = recipe.name
            exsistRecipe.steps.forEach { context.delete($0) }
            exsistRecipe.setSteps(recipe.steps.enumerated()
                .map { index, step in
                    return Step(
                        order: index,
                        name: step.name,
                        helpText: step.helpText,
                        seconds: Int(step.seconds) ?? 1,
                        water: Int(step.water) ?? 1
                    )
                }
            )
            try? context.save()
        } else {
            let newRecipe = Recipe(
                name: recipe.name,
                steps: recipe.steps.enumerated().map { index, step in
                    return Step(
                        order: index,
                        name: step.name,
                        helpText: step.helpText,
                        seconds: Int(step.seconds) ?? 1,
                        water: Int(step.water) ?? 1
                    )
                }
            )
            context.insert(newRecipe)
        }
    }
    
}
