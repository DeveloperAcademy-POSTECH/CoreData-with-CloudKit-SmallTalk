//
//  NoticeList.swift
//  SmallTalk
//
//  Created by devisaac on 2022/07/24.
//

import SwiftUI


struct NoticeList: View {
    struct FormConfig {
        var title: String
        var content: String
        var isEditing: Bool
    }

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Notice.noticed, ascending: false)
        ]
    )
    private var notices: FetchedResults<Notice>

    @State private var config: FormConfig = FormConfig(
        title: "",
        content: "",
        isEditing: false
    )


    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notices) { notice in
                        NavigationLink {
                            VStack {
                                Text(notice.content ?? "")
                            }
                        } label: {
                            Text(notice.title ?? "")
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        config.isEditing.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $config.isEditing) {
                Form {
                    Section("제목") {
                        TextField("", text: $config.title)
                    }
                    Section("내용") {
                        TextEditor(text: $config.content)
                    }
                    Button {
                        addItem()
                    } label: {
                        Text("작성하기")
                    }
                }
            }
        }
    }
}


extension NoticeList {
    @Sendable
    private func addItem() {
        Notice.add(
            title: config.title,
            content: config.content,
            context: viewContext
        )
        config.isEditing.toggle()
    }

    @Sendable
    private func delete(_ indexSet: IndexSet) {
        let deletions = indexSet.map { notices[$0] }
        Notice.delete(notices: deletions, context: viewContext)
    }
}
struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        NoticeList()
    }
}
