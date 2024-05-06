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
    @Attribute(.unique)
    let id: UUID = UUID()
    var name: String
    @Relationship
    var steps: [Step]
    let createdAt: Date = Date.now
    
    init() {
        self.name = ""
        self.steps = [.init()]
    }
    
    init(name: String, steps: [Step]) {
        assert(steps.count > 0, "steps must be greater than 0")
        self.name = name
        
        var accumulatedSeconds = 0
        var accumulatedWater = 0
        
        self.steps = steps
            .sorted(by: { $0.order < $1.order })
            .map { step in
                accumulatedSeconds += step.seconds
                accumulatedWater += step.water
                
                return Step(
                    order: step.order,
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

var sampleRecipe: Recipe = .init(name: "기본 레시피", steps: sampleSteps)

var sampleSteps: [Step] = [
    .init(order: 1, name: "뜸들이기", helpText: "원두를 충분히 적셔주세요", seconds: 20, accumulatedSeconds: 20, water: 40, accumulatedWater: 40),
    .init(order: 2, name: "첫번째 추출", helpText: "가운데부터 균일한 속도로 물을 부어주세요", seconds: 30, accumulatedSeconds: 50, water: 40, accumulatedWater: 80),
    .init(order: 3, name: "두번째 추출", helpText: "속도를 조금 높여 물을 부어주세요", seconds: 30, accumulatedSeconds: 80, water: 40, accumulatedWater: 120),
    .init(order: 4, name: "세번째 추출", helpText: "시간이 되면 드리퍼 내에 물이 남아있어도 추출을 마무리해주세요", seconds: 30, accumulatedSeconds: 110, water: 40, accumulatedWater: 160),
]