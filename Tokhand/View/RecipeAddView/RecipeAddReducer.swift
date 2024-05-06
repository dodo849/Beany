//
//  RecipeAddReducer.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture
import StackCoordinator


@Reducer
struct RecipeAddReducer {
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
    
    @ObservableState
    struct State: Equatable {
        var recipeName = ""
        var steps: [StepInputModel] = [StepInputModel()]
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case recipeNameChanged(_ text: String)
        case addStep
        case removeStep(_ index: Int)
        case save
        case cancel
    }
    
    var coordinator: BaseCoordinator<RecipeLink>
    
    init(coordinator: BaseCoordinator<RecipeLink>) {
        self.coordinator = coordinator
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
//            case .binding(\.stepCount):
//              state.sliderValue = .minimum(state.sliderValue, Double(state.stepCount))
//              return .none
            case .binding:
              return .none
            case .recipeNameChanged(let text):
                state.recipeName = text
                return .none
            case .addStep:
                state.steps.append(.init())
                return .none
            case .removeStep(let index):
                state.steps.remove(at: index)
                return .none
            case .save:
                coordinator.path.removeLast()
                return .none
            case .cancel:
                coordinator.path.removeLast()
                return .none
            }
        }
    }
}
