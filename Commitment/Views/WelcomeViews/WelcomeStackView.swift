//
//  WelcomeStackView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import SwiftData

struct WelcomeStackView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appModel: AppModel
    @State private var showFileImporter: Bool = false

    private let appVersion: String = "Build: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
    private let appBuild: String = "Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")"

    var body: some View {
        VStack(spacing: 10) {
            AppIcon()
                .padding(.bottom)

            HStack {
                Text("Welcome to ") +
                Text("Commitment")
                    .foregroundColor(Color.accentColor)
            }
            .font(.largeTitle)
            .fontWeight(.black)
            .fixedSize(horizontal: true, vertical: false)

            HStack {
                PillView(label: appBuild)
                PillView(label: appVersion)
            }

            WelcomeListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
                //                appModel.openRepo()
                showFileImporter.toggle()
//                dismiss()
            }
            .padding(.top, 30)
        }
//        .fileImporter(
//            isPresented: $showFileImporter,
//            allowedContentTypes: [.directory]
//        ) { result in
//            switch result {
//            case .success(let directory):
//                // gain access to the directory
//                let gotAccess = directory.startAccessingSecurityScopedResource()
//                if !gotAccess { return }
//
//                self.appModel.bookmarks.storeFolderInBookmark(url: directory)
//                addItem(url: directory)
//                // access the directory URL
//                // (read templates in the directory, make a bookmark, etc.)
//                //                onTemplatesDirectoryPicked(directory)
//                // release access
//                directory.stopAccessingSecurityScopedResource()
//            case .failure(let error):
//                // handle error
//                print(error)
//            }
//        }
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

struct WelcomeStackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeStackView()
    }
}
