//
//  AppModel.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import Boutique
import Foundation
import KeyboardShortcuts

//
//class AppModel: ObservableObject {
//    static let shared = AppModel()
//    // TODO: AppStorage?
//    // TODO: Move to ViewState?
////    @AppStorage("WindowMode") var windowMode: SplitModeOptions = .history
////    @AppStorage("Editor") var editor: ExternalEditors = .xcode
////    @StoredValue(key: "Editor") var editor: ExternalEditor = .xcode
////    @StoredValue(key: "WindowMode") var windowMode: SplitModeOptions = .history
////    @StoredValue(key: "GitUser") var user: GitUser? = nil
////    @StoredValue(key: "ActiveRepository") var activeRepositoryId: RepoState.ID? = nil
//    /// Creates a @Stored property to handle an in-memory and on-disk cache of type.
////    @Stored(in: .repositoryStore) var repos
//
////
////    @Published var isRepoSelectOpen: Bool = false {
////        didSet {
////            if isRepoSelectOpen {
////                isBranchSelectOpen = false
////            }
////        }
////    }
////    @Published var isBranchSelectOpen: Bool = false {
////        didSet {
////            if isBranchSelectOpen {
////                isRepoSelectOpen = false
////            }
////        }
////    }
////
////    func dismissModal() {
////        self.isRepoSelectOpen = false
////    }
//}
