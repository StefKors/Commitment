//
//  ContentView.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var repositories: [CodeRepository]

    var body: some View {
        VStack {
            ForEach(repositories) { repo in
                Text(repo.path.description)
            }

        }
    }

    private func addItem(url: URL) {
        withAnimation {
            let newRepository = CodeRepository(path: url)
            modelContext.insert(newRepository)
        }
    }

    // private func deleteItems(offsets: IndexSet) {
    //     withAnimation {
    //         for index in offsets {
    //             modelContext.delete(recordings[index])
    //         }
    //     }
    // }
}

#Preview {
    ContentView()
}
