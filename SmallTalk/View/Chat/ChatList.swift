//
//  ChatList.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import SwiftUI

struct ChatList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Chat.created, ascending: false)
        ],
        animation: .default
    )
    private var chats: FetchedResults<Chat>

    @State var message: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chats) { chat in
                        NavigationLink {
                            VStack {
                                Text(chat.content ?? "")
                            }
                        } label: {
                            Text(chat.content ?? "")
                        }
                    }
                    .onDelete(perform: delete)
                }
                HStack {
                    TextField("시덥지 않은 일을 알려주세요", text: $message)
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .frame(minWidth: 40)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}


extension ChatList {
    private func addItem() {
        Chat.add(content: message, context: viewContext)
        message = ""
    }

    @Sendable
    private func delete(_ indexSet: IndexSet) {
        let deletions = indexSet.map { chats[$0] }
        Chat.delete(chats: deletions, context: viewContext)
    }
}


struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
