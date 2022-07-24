//
//  SmallTalkApp.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import SwiftUI

@main
struct SmallTalkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
