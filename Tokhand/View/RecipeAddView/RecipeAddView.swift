//
//  RecipeAddView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator


struct RecipeAddView: View {
    struct StepInputModel: Equatable, Identifiable {
        var id: UUID = UUID()
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
    @Environment(\.modelContext) var context
    var coordinator: BaseCoordinator<RecipeLink>
    
    @State var recipeName = ""
    @State var steps: [StepInputModel] = [StepInputModel()]
    
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
                    TextField("레시피를 구분할 이름을 작성해주세요", text: $recipeName)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                
                Divider().padding(.vertical, 10)
                
                Text("추출 단계")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                VStack {
                    ForEach(steps.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                TextField("순서 혹은 단계 이름을 입력해주세요", text: $steps[index].name)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                
                                TextField("시간", text: $steps[index].seconds)
                                    .keyboardType(.numberPad)
                                Text("초")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Divider()
                                Image(systemName: "drop")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .frame(maxWidth: 15)
                                TextField("물 양", text:  $steps[index].water)
                                    .keyboardType(.numberPad)
                                Text("ml")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            HStack {
                                Image(systemName: "doc")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                TextField("추출 시 참고할 도움말을 작성해주세요", text: $steps[index].helpText)
                            }
                            HStack {
                                Button(action: addStep) {
                                    Text("추가 하기")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .animation(.none, value: steps)
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
                                            .animation(.none, value: steps)
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
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.strongCoffee)
        .scrollIndicators(.hidden)
        .addHideKeyboardGuesture()
        .customBackButton() {
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
    }
    
    func addStep() {
        steps.append(.init())
    }
    
    func removeStep(_ index: Int) {
        steps.remove(at: index)
    }
    
    func saveRecipe() {
        coordinator.path.removeLast()
        let newRecipe = Recipe(
            name: recipeName,
            steps: steps.enumerated().map { (index, item) in
            Step(
                order: index,
                name: item.name,
                helpText: item.helpText,
                seconds: Int(item.seconds) ?? 0,
                water: Int(item.water) ?? 0
            )
        })
        context.insert(newRecipe)
    }
    
}

#Preview {
    RecipeAddView(
        coordinator: BaseCoordinator<RecipeLink>()
    )
}
