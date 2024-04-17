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
                .task {
                    _ = await DiaryClassifierUseCase.shared.predict(for: "어제 막걸리를 마셔서 그런지 모르겠지만 아침에 너무 피곤하고 머리가 멍해서 계속 잠만 잤다. 일어나니 11시에 가까워서 ....... 후다닥 개발을 조금 했지만 할일이 많다.")
                }
        }
    }

    @MainActor
    private func resetModelContainer() {
        do {
            try modelContainer.mainContext.delete(model: Year.self)
            try modelContainer.mainContext.delete(model: Month.self)
            try modelContainer.mainContext.delete(model: Log.self)
        } catch {
            print("Failed to clear all Years")
        }
    }
}
