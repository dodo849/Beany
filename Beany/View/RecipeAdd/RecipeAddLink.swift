//
//  RecipeAddLink.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/8/24.
//

import SwiftUI

import ComposableArchitecture
import StackCoordinator

enum RecipeAddLink: LinkProtocol {
    func matchView() -> any View {
        return EmptyView()
    }
}
