//
//  UserDefaultConstant.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation

enum UserDefaultsKey: String {
    case selectedRecipeId
    case isFirstInstall
    case isSoundOn
}

struct UserDefaultsRepository {
    
    static func save<T>(_ value: T, forKey key: UserDefaultsKey) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    static func get<T>(forKey key: UserDefaultsKey) -> T {
        if let value = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return value
        } else {
            fatalError("key not found")
        }
    }
}
