//
//  Step.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation
import SwiftData

@Model
class Step: Equatable, Identifiable {
    @Attribute(.unique)
    let id: UUID = UUID()
    var order: Int
    var name: String
    var helpText: String
    var seconds: Int
    var accumulatedSeconds: Int?
    var water: Int
    var accumulatedWater: Int?
    let createdAt: Date = Date.now
    
    init() {
        self.order = 0
        self.name = ""
        self.helpText = ""
        self.seconds = 0
        self.water = 0
    }
    
    init(
        order: Int,
        name: String,
        helpText: String,
        seconds: Int,
        accumulatedSeconds: Int? = 0,
        water: Int,
        accumulatedWater: Int? = 0
    ) {
        self.order = order
        self.name = name
        self.helpText = helpText
        self.seconds = seconds
        self.accumulatedSeconds = accumulatedSeconds
        self.water = water
        self.accumulatedWater = accumulatedWater
    }
}
