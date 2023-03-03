//
//  Shell+ViewModel.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation
import OSLog

enum ShellError: Error {
    case NoProcessLines
}

/// The viewmodel for running shell scripts while displaying their output
/// based on: https://stackoverflow.com/a/72122123/3199999
@MainActor class ShellViewModel: ObservableObject {
    @Published var output: String? = nil
    @Published var isRunning: Bool = false

    let shell: Shell
    private let signposter = OSSignposter()

    init(shell: Shell) {
        self.shell = shell
    }

    func run(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL? = nil
    ) async {
        // Setup up state
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)
        isRunning = true
        let location = currentDirectoryURL ?? self.shell.workspace
        let process = ProcessWithLines(executable, command, in: location)

        // Run action
        do {
            try await process.start()

            guard let lines = await process.lines else {
                throw ShellError.NoProcessLines
            }

            for try await line in lines {
                // Update output
                print(output)
                self.output = line
            }

            // Reset output
            self.output = nil
        } catch {
            // Show error in output
            self.output = error.localizedDescription
        }

        // Finish up state
        isRunning = false
        self.signposter.endInterval("run", state)
    }

    func push() async throws {
        let remote = try await self.shell.remote()
        let branch = try await self.shell.branch()
        await self.run(.git, ["push", remote, branch])
    }
}
