//
//  KekaDemoAppApp.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import SwiftUI

@main
struct KekaDemoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
