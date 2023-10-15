//
//  Shell+Run.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "Shell")

extension Shell {
    @discardableResult
    func runTask(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL? = nil
    ) async -> String {
        let location = currentDirectoryURL ?? self.workspace
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)

        let process = Shell.setup(Process(), executable, command, in: location)
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe


        do {
            let result: String = try await withCheckedThrowingContinuation { continuation in
                process.terminationHandler = { process in
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = data.toShellOutput

                    switch process.terminationReason {
                    case .uncaughtSignal:
                        let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
                        self.signposter.endInterval("run", state)
                        continuation.resume(throwing: error)
                    case .exit:
                        self.signposter.endInterval("run", state)
                        continuation.resume(returning: output)
                    @unknown default:
                        //TODO: theoretically, this ought not to happen
                        self.signposter.endInterval("run", state)
                        continuation.resume(returning: output)
                    }
                }

                do {
                    try process.run()
                } catch {
                    continuation.resume(throwing: error)
                }
            }

            return result
        } catch {
            Commitment.log.error("Run Task failed with: \(error.localizedDescription)")
            return "Run Task failed with: \(error.localizedDescription)"
        }
    }

    /// The viewmodel for running shell scripts while displaying their output
    /// based on: https://stackoverflow.com/a/72122123/3199999
    func runActivity(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL
    ) async {
        // Setup up state
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)
        // isRunning = true
        let execPath = Bundle.main.resourcePath ?? "" + "/" + "Executables/git-arm64/git-core"
        let appHome = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true)

        var envConfig = [
            // TODO: Support Intel
            "GIT_CONFIG_NOSYSTEM": "true",
            "GIT_EXEC_PATH": execPath
        ]

        if let appHome {
            envConfig["HOME"] = appHome.path(percentEncoded: false)
        }
        process = Process()
        let stdout = Pipe()
        // let stdin = Pipe()
        let stderr = Pipe()
        // process.standardInput = stdin
        process.standardOutput = stdout
        process.standardError = stderr
        process.environment = envConfig
        process.launchPath = executable.url.path()
        process.qualityOfService = .userInitiated
        process.arguments = command
        process.currentDirectoryURL = currentDirectoryURL

        do {
            try process.run()

            for try await line in stdout.fileHandleForReading.bytes.lines {
                // Update output
                self.output = line
            }

            for try await line in stderr.fileHandleForReading.bytes.lines {
                // Update output
                self.output = line
            }
        } catch {
            // Show error in output
            self.output = error.localizedDescription
        }
        process.waitUntilExit()
        self.signposter.endInterval("run", state)
    }
}
