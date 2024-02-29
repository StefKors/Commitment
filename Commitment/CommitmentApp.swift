//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI
import Foundation
import WindowManagement
import HotKey
import SwiftData
import UniformTypeIdentifiers

extension SceneID {
    static let mainWindow = SceneID("MainWindow")
}

/// Project todo / idea list:
/// - 3rd diff showing final state vs unified diff https://matklad.github.io/2023/10/23/unified-vs-split-diff.html
/// - onboarding flow
/// - CLI tool for controlling the app https://www.youtube.com/watch?v=hPEDjbb_BD0
/// - File A / File B header blocks like kaleidoscope https://blog.kaleidoscope.app/wp-content/uploads/2022/04/ksdiff-three.jpg
/// - Theming options for UI elements
/// - Theming options for Syntax Highlighting
/// - Import and parse VSCode and Xcode theme files
/// - Iconset
/// - Update appicon, designed for information, show diff stats and current project / branch
/// - Menubar app like gitlab app, incl github, bitbucket
/// - Localise with that app that pulls localisations from apple products
/// - Watch for changes across projects, so when opening the quick commit window it opens with your current working project
/// - Switch projects in quick commit window
/// - Open full window from quick commit window
/// - Better automatic commit tiles and descriptions
/// - Builtin support for semver commit titles / messages
/// - spotlight support? https://betterprogramming.pub/implement-core-spotlight-in-a-swiftui-app-859cb703f55d
/// - quick view previews support
/// - https://commit-chronicle.github.io/
/// https://github.com/gonzalezreal/swift-markdown-ui/blob/main/Examples/Demo/Demo/SyntaxHighlighter/SplashCodeSyntaxHighlighter.swift

@main
struct CommitmentApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: CommitmentAppDelegate
    @Environment(\.dismissWindow) private var dismissWindow
    // TODO: How to handle shell?

    init() {
        NSWindow.alwaysUseActiveAppearance = true
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CodeRepository.self,
            Bookmark.self,
            GitFileStatus.self,
            GitDiff.self,
            Credential.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    let code: String = """
//
//  FileStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct UndoAction: Identifiable, Equatable {
    let type: UndoActionType
    let arguments: [String]
    let id: UUID = .init()
    let createdAt: Date = .now
    var subtitle: String? = nil

    func test() async -> Int {
        return 12
    }
}

extension Theme {
    public static let commitmentDark = Theme(
        [
            "type": Theme.Value(color: Color(ThemeColors.Dark.lightBlue)),
            "class": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
            "class.system": Theme.Value(color: Color(ThemeColors.Dark.yellow))
        ]
    )
}

struct FileStatsView: View {
    let stats: GitFileStats?

    var count: Int {
        var value = 1
        value += 5
        return value
    }

    var body: some View {
        if let stats {
            HStack(spacing: 8) {
                Text("++\\(stats.insertions)")
                    .foregroundColor(Color("GitHubDiffGreenBright"))
                Divider()
                    .frame(maxHeight: 16)
                Text("--\\(stats.deletions)")
                    .foregroundColor(Color("GitHubDiffRedBright"))
                Divider()
            }
            .fontDesign(.monospaced)
        }
    }
}

struct FileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FileStatsView(stats: GitFileStats("4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"))
    }
}

"""
    let text = """
func test() async -> Int {
    return 12
}
"""



    var body: some Scene {
        Window("commitment", id: "test window") {
                HighlightedSTTextView(text)
        }


        SwiftUI.Settings {
            SettingsWindow()
                .frame(width: 650, height: 400)
//                .hideSidebarToggle()
                .modelContainer(sharedModelContainer)
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        .defaultSize(width: 650, height: 400)

        WindowGroup(id: SceneID.mainWindow.id, for: URL.self) { $repositoryID in
            ContentView(repositoryID: $repositoryID)
        }
        .modelContainer(sharedModelContainer)
        .register(.mainWindow)
        .enableOpenWindow()
        .titlebarAppearsTransparent(true)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            SidebarCommands()
            //            AppCommands(repo: appModel.activeRepo, appModel: appModel)
            //            OverrideCommands()
            TextEditingCommands()
        }
    }
}
