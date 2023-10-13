//
//  AddRepoView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import SwiftData

struct AddRepoView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.modelContext) private var modelContext

    @State private var showFileImporter: Bool = false

    var body: some View {
        Button(action: { showFileImporter.toggle() }, label: {
            Label("Add folder", systemImage: "plus.rectangle.on.folder")
        })
        .buttonStyle(.plain)
        .foregroundColor(.secondary)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory]
        ) { result in
            switch result {
            case .success(let directory):
                // gain access to the directory
                let gotAccess = directory.startAccessingSecurityScopedResource()
                if !gotAccess { return }
                addItem(url: directory)
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }

    private func addItem(url: URL) {
        withAnimation {
            do {
                let newRepository = try CodeRepository(path: url)
                modelContext.insert(newRepository)
            } catch {
                print("failed to create code repo due to bookmark")
            }
        }
    }
}

struct AddRepoView_Previews: PreviewProvider {
    static var previews: some View {
        AddRepoView()
    }
}
