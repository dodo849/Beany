//
//  TokhandApp.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture
import StackCoordinator

@main
struct TokhandApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            Step.self,
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RootBuilder { path in
                TimerBuilder()
            }
            //            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
