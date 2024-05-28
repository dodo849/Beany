//
//  SettingLink.swift
//  Beany
//
//  Created by DOYEON LEE on 5/27/24.
//

import Foundation
import SwiftUI

import StackCoordinator

enum SettingLink: LinkProtocol {
    case contactUsSheet
    
    func matchView() -> any View {
        switch self {
        case .contactUsSheet:
            return ContactUsSheet()
        }
    }
}
