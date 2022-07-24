//
//  ContentView.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            ChatList()
                .tabItem {
                    Label("Chat", systemImage: "bubble.right")
                }
            NoticeList()
                .tabItem {
                    Label("Notice", systemImage: "speaker")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
