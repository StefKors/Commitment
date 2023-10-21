//
//  Shell+Run.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "Shell")

import Foundation

/// Namespace for utilities to execute a child process.
enum Exec {
    /// How to handle stderr output from the child process.
    enum Stderr {
        /// Treat stderr same as parent process.
        case inherit
        /// Send stderr to /dev/null.
        case discard
        /// Merge stderr with stdout.
        case merge
    }

    /// The result of running the child process.
    struct Results {
        /// The process's exit status.
        let terminationStatus: Int32
        /// The data from stdout and optionally stderr.
        let data: Data
        /// The `data` reinterpreted as a string with whitespace trimmed; `nil` for the empty string.
        var string: String? {
            let encoded = String(data: data, encoding: .utf8) ?? ""
            let trimmed = encoded.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
    }

    /**
     Run a command with arguments and return its output and exit status.

     - parameter command: Absolute path of the command to run.
     - parameter arguments: Arguments to pass to the command.
     - parameter currentDirectory: Current directory for the command.  By default
     the parent process's current directory.
     - parameter stderr: What to do with stderr output from the command.  By default
     whatever the parent process does.
     */
    static func run(_ command: String,
                    _ arguments: String...,
                    currentDirectory: String = FileManager.default.currentDirectoryPath,
                    stderr: Stderr = .inherit) -> Results {
        return run(command, arguments, currentDirectory: currentDirectory, stderr: stderr)
    }

    /**
     Run a command with arguments and return its output and exit status.

     - parameter command: Absolute path of the command to run.
     - parameter arguments: Arguments to pass to the command.
     - parameter currentDirectory: Current directory for the command.  By default
     the parent process's current directory.
     - parameter stderr: What to do with stderr output from the command.  By default
     whatever the parent process does.
     */
    static func run(_ command: String,
                    _ arguments: [String] = [],
                    currentDirectory: String = FileManager.default.currentDirectoryPath,
                    stderr: Stderr = .inherit) -> Results {
        let process = Process()
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe

        switch stderr {
        case .discard:
            // FileHandle.nullDevice does not work here, as it consists of an invalid file descriptor,
            // causing process.launch() to abort with an EBADF.
            process.standardError = FileHandle(forWritingAtPath: "/dev/null")!
        case .merge:
            process.standardError = pipe
        case .inherit:
            break
        }

        do {
#if canImport(Darwin)
            if #available(macOS 10.13, *) {
                process.executableURL = URL(fileURLWithPath: command)
                process.currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
                try process.run()
            } else {
                process.launchPath = command
                process.currentDirectoryPath = currentDirectory
                process.launch()
            }
#else
            process.executableURL = URL(fileURLWithPath: command)
            process.currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
            try process.run()
#endif
        } catch {
            return Results(terminationStatus: -1, data: Data())
        }

        let file = pipe.fileHandleForReading
        let data = file.readDataToEndOfFile()
        process.waitUntilExit()
        return Results(terminationStatus: process.terminationStatus, data: data)
    }
}

extension Shell {
    @discardableResult
    func runTask(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL? = nil
    ) async -> String {
        let location = currentDirectoryURL ?? self.workspace

//        let execPath = Bundle.main.resourcePath ?? "" + "/" + "Executables/git-arm64/git-core"
//        let appHome = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true)
//
//        var envConfig = [
//            // TODO: Support Intel
//            "GIT_CONFIG_NOSYSTEM": "true",
//            "GIT_EXEC_PATH": execPath
//        ]
//
//        if let appHome {
//            envConfig["HOME"] = appHome.path(percentEncoded: false)
//        }
//
//        process.environment = envConfig
//        process.launchPath = executable.url.path()
//        process.qualityOfService = .userInitiated
//        process.arguments = command
//        process.currentDirectoryURL = currentDirectoryURL
//        return process

        let execResult = Exec.run(executable.url.path(), command, currentDirectory: location.absoluteString, stderr: .merge)
        return execResult.string ?? ""
//
//        let signpostID = signposter.makeSignpostID()
//        let state = signposter.beginInterval("run", id: signpostID)
//
//        let process = Shell.setup(Process(), executable, command, in: location)
//        let pipe = Pipe()
//        process.standardOutput = pipe
//        process.standardError = pipe
//
//        do {
//            let result: String = try await withCheckedThrowingContinuation { continuation in
//                process.terminationHandler = { process in
//                    let data = try? pipe.fileHandleForReading.readToEnd()
//                    let output = data?.toShellOutput ?? "failed"
//                    print(output)
//                    switch process.terminationReason {
//                    case .uncaughtSignal:
//                        let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
//                        self.signposter.endInterval("run", state)
//                        continuation.resume(throwing: error)
//                    case .exit:
//                        self.signposter.endInterval("run", state)
//                        continuation.resume(returning: output)
//                    @unknown default:
//                        //TODO: theoretically, this ought not to happen
//                        self.signposter.endInterval("run", state)
//                        continuation.resume(returning: output)
//                    }
//                }
//
//                do {
//                    try process.run()
//                } catch {
//                    Commitment.log.error("Catching process error: \(error.localizedDescription)")
//                    continuation.resume(throwing: error)
//                }
//            }
//
//            process.waitUntilExit()
//            let status = process.terminationStatus
//
//            if status == 0 {
//                print("Task succeeded.")
//            } else {
//                print("Task failed.")
//            }
//            return result
//        } catch {
//            Commitment.log.error("Run Task failed with: \(error.localizedDescription)")
//            return "Run Task failed with: \(error.localizedDescription)"
//        }
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
