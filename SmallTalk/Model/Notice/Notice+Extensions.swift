//
//  Notice+Extensions.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import CoreData

extension Notice {
    static func add(title: String, content: String, context: NSManagedObjectContext) {
        context.perform {
            let newNotice = Notice(context: context)
            newNotice.id = UUID()
            newNotice.noticed = Date()
            newNotice.title = title
            newNotice.content = content
            try? context.save()
        }
    }

    static func delete(notices: [Notice], context: NSManagedObjectContext) {
        context.delete(notices)
    }
}

extension Notice: UUIDObject {}
