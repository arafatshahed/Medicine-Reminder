//
//  Medicine_ReminderApp.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/6/23.
//

import SwiftUI

@main
struct Medicine_ReminderApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
