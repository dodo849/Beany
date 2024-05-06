//
//  RecipeAddView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import StackCoordinator

struct RecipeDto: Equatable {
    var name: String
    var steps: [StepDto]
    
    init() {
        self.name = ""
        self.steps = [.init()]
    }
}

struct StepDto: Equatable {
    var name: String
    var seconds: String
    var water: String
    var helpText: String
    
    init() {
        self.name = ""
        self.seconds = ""
        self.water = ""
        self.helpText = ""
    }
}

struct RecipeAddView: View {
    @Environment(\.modelContext) private var modelContext
    var coordinator: BaseCoordinator<RecipeLink>
    
    @State var recipe = RecipeDto()
    @State var text = ""
    
    var body: some View {
        ScrollView{
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
                    TextField("레시피를 구분할 이름을 작성해주세요", text: $recipe.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                }
                Divider().padding(.vertical, 10)
                Text("추출 단계")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                ForEach(recipe.steps.indices, id: \.self) { index in
                    VStack {
                        HStack {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            TextField("순서 혹은 ~~ 을 입력해주세요", text: $recipe.steps[index].name)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            
                            TextField("시간", text: $recipe.steps[index].seconds)
                                .keyboardType(.numberPad)
                            Text("초")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                            Divider()
                            Image(systemName: "drop")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .frame(maxWidth: 15)
                            TextField("물 양", text:  $recipe.steps[index].water)
                                .keyboardType(.numberPad)
                            Text("ml")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        HStack {
                            Image(systemName: "doc")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                            TextField("추출 시 참고할 도움말을 작성해주세요", text: $recipe.steps[index].helpText)
                        }
                    }
                    .padding()
                    .background(.coffee.opacity(0.1))
                    .cornerRadius(15)
                }
                .onDelete(perform: deleteItem)
                
                
                Button(action: { recipe.steps.append(StepDto()) }) {
                    Text("단계 추가")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .animation(.none, value: recipe)
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
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.strongCoffee)
        .customBackButton()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    coordinator.path.removeLast()
                }) {
                    Text("저장")
                        .foregroundColor(.strongCoffee)
                }
            }
        }
    }
    
    func deleteItem(at indexSet: IndexSet) {
        recipe.steps.remove(atOffsets: indexSet)
    }
}

#Preview {
    RecipeAddView(coordinator: BaseCoordinator<RecipeLink>())
}
