//
//  TokhandApp.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/5/24.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct TokhandApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
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
            NavigationStack {
                TimerView(
                    store: Store(initialState: TimerReducer.State()) {
                        TimerReducer()
                    }
                )
            }
//            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
