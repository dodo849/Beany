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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Recipe.self,
        Step.self,
        Item.self
    ])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@main
struct BeanyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootBuilder { _ in
                TimerBuilder()
            }
            //            ContentView()
            .onAppear {
                FirstInstallAction.shared.execute()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
