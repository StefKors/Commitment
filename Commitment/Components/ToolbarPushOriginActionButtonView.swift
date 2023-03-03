//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI
import KeychainAccess

actor ProcessWithLines: ObservableObject {
    private let process = Process()
    private let stdin = Pipe()
    private let stdout = Pipe()
    private let stderr = Pipe()
    private var buffer = Data()
    @Published private(set) var lines: AsyncLineSequence<FileHandle.AsyncBytes>?

    init() {
        process.standardInput = stdin
        process.standardOutput = stdout
        process.standardError = stderr
        process.executableURL = URL(filePath: Bundle.main.resourcePath ?? "" + "/" + "Executables/git-arm64/git-core")
        process.arguments = ["log", "--oneline"]
    }

    func start() throws {
        lines = stdout.fileHandleForReading.bytes.lines
        try process.run()
    }

    func terminate() {
        process.terminate()
    }

    func send(_ string: String) {
        guard let data = "\(string)\n".data(using: .utf8) else { return }
        stdin.fileHandleForWriting.write(data)
    }
}

struct ActivityArrow: View {
    let isPushingBranch: Bool
    var body: some View {
        if isPushingBranch {
            Image(systemName: "arrow.2.circlepath")
                .imageScale(.medium)
                .rotation(isEnabled: true)
        } else {
            Image(systemName: "arrow.up")
                .imageScale(.medium)
        }
    }
}

struct ToolbarPushOriginActionButtonView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var appModel: AppModel
    let remote: String = "origin"

    @State private var isPushingBranch: Bool = false
    @State private var showMover: Bool = false

    @StateObject private var process = ProcessWithLines()

    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // .fontWeight(.bold)
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
                    }

                    GroupBox {
                        Text(repo.commitsAhead.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // .fontWeight(.bold)
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
    }

    func handleButton() {
        Task {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isPushingBranch = true
            }

            try await process.start()
            guard let lines = await process.lines else { return }

            for try await line in lines {
                print(line)
            }

            // let output2 = try await self.repo.shell.push()
            // print(output2)
            // print("creating .gitconfig")

            try await self.repo.refreshRepoState()
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isPushingBranch = false
            }
        }
    }
}

struct ToolbarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPushOriginActionButtonView()
    }
}
