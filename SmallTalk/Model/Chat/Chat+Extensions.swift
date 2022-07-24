//
//  Chat+Extensions.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import Foundation
import CoreData

extension Chat {
    static func add(content: String, context: NSManagedObjectContext) {
        context.perform {
            let newChat = Chat(context: context)
            newChat.id = UUID()
            newChat.created = Date()
            newChat.content = content
            try? context.save()
        }
    }

    static func delete(chats: [Chat], context: NSManagedObjectContext) {
        context.delete(chats)
    }
}

extension Chat: UUIDObject {}
