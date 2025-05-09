//
//  DiagramNewApp.swift
//  DiagramNew
//
//  Created by Phil Kirby on 5/9/25.
//

import SwiftUI

@main
struct DiagramNewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
