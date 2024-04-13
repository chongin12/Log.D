//
//  LogDApp.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI
import SwiftData

@main
struct LogDApp: App {
    let modelContainer: ModelContainer
    init() {
        do {
            modelContainer = try ModelContainer(for: Year.self)
//            resetModelContainer()
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(modelContainer)
        }
    }

    @MainActor
    private func resetModelContainer() {
        do {
            try modelContainer.mainContext.delete(model: Year.self)
        } catch {
            print("Failed to clear all Years")
        }
    }
}
