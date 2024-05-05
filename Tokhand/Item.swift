//
//  Item.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
