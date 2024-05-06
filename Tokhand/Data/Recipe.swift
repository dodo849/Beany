//
//  Recipe.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import Foundation
import SwiftData

@Model
class Recipe: Equatable, Identifiable {
    
    @Attribute(.unique) var name: String
    var steps: [Step]
    
    init() {
        self.name = ""
        self.steps = [.init()]
    }
    
    init(name: String, steps: [Step]) {
        assert(steps.count > 0, "steps must be greater than 0")
        self.name = name
        
        var accumulatedSeconds = 0
        var accumulatedWaterQuantity = 0
        self.steps = steps.map { step in
            accumulatedSeconds += step.seconds
            accumulatedWaterQuantity += step.water
            
            return Step(
                name: step.name,
                helpText: step.helpText,
                seconds: step.seconds,
                accumulatedSeconds: accumulatedSeconds,
                water: step.water,
                accumulatedWater: accumulatedWaterQuantity
            )
        }
    }
    
    private func calculateCumulative() {
//        self.steps = self.steps.sorted { $0.order < $1.order }
        
        var accumulatedSeconds = 0
        var accumulatedWater = 0
        
        self.steps = self.steps.map { step in
            accumulatedSeconds += step.seconds
            accumulatedWater += step.water
            
            return Step(
                name: step.name,
                helpText: step.helpText,
                seconds: step.seconds,
                accumulatedSeconds: accumulatedSeconds,
                water: step.water,
                accumulatedWater: accumulatedWater
            )
        }
    }
}

@Model
class Step: Equatable, Identifiable {
    var name: String
    var helpText: String
    var seconds: Int
    var accumulatedSeconds: Int?
    var water: Int
    var accumulatedWater: Int?
    
    init() {
        self.name = ""
        self.helpText = ""
        self.seconds = 0
        self.water = 0
    }
    
    init(
        name: String,
        helpText: String,
        seconds: Int,
        accumulatedSeconds: Int?,
        water: Int,
        accumulatedWater: Int?
    ) {
        self.name = name
        self.helpText = helpText
        self.seconds = seconds
        self.accumulatedSeconds = accumulatedSeconds
        self.water = water
        self.accumulatedWater = accumulatedWater
    }
}

var sampleRecipe: Recipe = .init(name: "기본 레시피", steps: sampleSteps)

var sampleSteps: [Step] = [
    .init(name: "뜸들이기", helpText: "원두를 충분히 적셔주세요", seconds: 20, accumulatedSeconds: 20, water: 40, accumulatedWater: 40),
    .init(name: "첫번째 추출", helpText: "가운데부터 균일한 속도로 물을 부어주세요", seconds: 30, accumulatedSeconds: 50, water: 40, accumulatedWater: 80),
    .init(name: "두번째 추출", helpText: "속도를 조금 높여 물을 부어주세요", seconds: 30, accumulatedSeconds: 80, water: 40, accumulatedWater: 120),
    .init(name: "세번째 추출", helpText: "시간이 되면 드리퍼 내에 물이 남아있어도 추출을 마무리해주세요", seconds: 30, accumulatedSeconds: 110, water: 40, accumulatedWater: 160),
]
