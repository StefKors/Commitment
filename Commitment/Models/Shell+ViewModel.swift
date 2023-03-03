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

    private let signposter = OSSignposter()

    func run(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL
    ) async {
        // Setup up state
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)
        isRunning = true
        let process = ProcessWithLines(executable, command, in: currentDirectoryURL)

        // Run action
        do {
            try await process.start()
            print("output 🔥🔥🔥🔥")
            guard let lines = await process.lines else {
                throw ShellError.NoProcessLines
            }

            for try await line in lines {
                // Update output
                print("output 🔥🔥🔥🔥🔥🔥🔥 \(output)")
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
}
