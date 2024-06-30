//
//  UserDefaultConstant.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation
import OSLog

enum UserDefaultsKey: String {
    case selectedRecipeId
    case isFirstInstall
    case isSoundOn
}

struct UserDefaultsRepository {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "UserDefaultsRepository"
    )
    
    static func save<T>(_ value: T, forKey key: UserDefaultsKey) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    static func get<T>(forKey key: UserDefaultsKey, _ defaultValue: T) -> T {
        if let value = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return value
        } else {
            logger.warning("Key \(key.rawValue) not found")
            return defaultValue
        }
    }
}
