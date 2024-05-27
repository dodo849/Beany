//
//  Author.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation

enum Author: Codable {
    case admin
    case user
    
    var description: String {
        switch self {
        case .admin:
            return "기본"
        case .user:
            return "등록"
        }
    }
}
