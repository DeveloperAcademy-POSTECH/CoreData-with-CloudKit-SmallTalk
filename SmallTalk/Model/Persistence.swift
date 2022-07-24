//
//  Persistence.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newItem = Chat(context: viewContext)
            newItem.created = Date()
            newItem.content = "Item at \(index)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SmallTalk")

        // Container의 persistentStoreDscriptions를 통해서
        // Public / Private Database에 사용될 Store를 세팅합니다
        // SmallTalk.xcdatamodeld 파일에서 새로 작성한 Configuration을 사용해서
        // 2개의 Store Dscription을 만들어서 Container에게 전달하여 Store를 생성합니다

        // Default Description을 가져와서 새로운 description 작성에 사용합니다
        // 각각 Configuration 세팅은 어떤 값들을 세팅하는지 조사 해보고 사용해주세요
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Unresolved error with loading persistentStoreDescriptions")
        }

        // MARK: Public Database
        let publicStoreUrl = description.url!
            .deletingLastPathComponent()
            .appendingPathComponent("SmallTalk-public.sqlite")
        let identifier = description.cloudKitContainerOptions!.containerIdentifier

        let publicDescription = NSPersistentStoreDescription(url: publicStoreUrl)
        publicDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        publicDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        let publicOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: identifier)
        publicOptions.databaseScope = .public
        publicDescription.cloudKitContainerOptions = publicOptions
        publicDescription.configuration = "Public"

        // MARK: Private Database
        let privateStoreUrl = description.url!
            .deletingLastPathComponent()
            .appendingPathComponent("SmallTalk-private.sqlite")
        let privateIdentifier = description.cloudKitContainerOptions!.containerIdentifier

        let privateDescription = NSPersistentStoreDescription(url: privateStoreUrl)
        privateDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        privateDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        let privateOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: privateIdentifier)
        privateOptions.databaseScope = .private
        privateDescription.cloudKitContainerOptions = privateOptions
        privateDescription.configuration = "Private"

        container.persistentStoreDescriptions = [
            publicDescription,
            privateDescription
        ]

        // inMemory 관련 작업을 모든 Store에 대해서 할 수 있도록 수정합니다
        if inMemory {
            _ = container.persistentStoreDescriptions
                .map { $0.url = URL(fileURLWithPath: "/dev/null") }
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
