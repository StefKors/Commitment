//
//  self.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import Foundation
import System
import OSLog

public struct ProcessError : Error {
    public var terminationStatus:Int32
    public var output:String
}

enum Executable: String {
    case git
    case gitRemoteHttp = "git-remote-http"

    var url: URL {
        Bundle.main.url(forResource: self.rawValue, withExtension: "")!
    }
}


// https://stackoverflow.com/a/72122123/3199999
// let process = ProcessWithLines(url: url)

// try await process.start()
// guard let lines = await process.lines else { return }
//
// for try await line in lines {
//     print(line)
// }

// actor ProcessWithStream {
//     private let process = Process()
//     private let stdin = Pipe()
//     private let stdout = Pipe()
//     private let stderr = Pipe()
//     private var buffer = Data()
//
//     init(url: URL) {
//         process.standardInput = stdin
//         process.standardOutput = stdout
//         process.standardError = stderr
//         process.executableURL = url
//     }
//
//     func start() throws {
//         try process.run()
//     }
//
//     func terminate() {
//         process.terminate()
//     }
//
//     func send(_ string: String) {
//         guard let data = "\(string)\n".data(using: .utf8) else { return }
//         stdin.fileHandleForWriting.write(data)
//     }
//
//     func stream() -> AsyncStream<Data> {
//         AsyncStream(Data.self) { continuation in
//             stdout.fileHandleForReading.readabilityHandler = { handler in
//                 continuation.yield(handler.availableData)
//             }
//             process.terminationHandler = { handler in
//                 continuation.finish()
//             }
//         }
//     }
// }


class Shell {
    var workspace: URL

    // Create a signposter that uses the default subsystem and category.
    private let signposter = OSSignposter()

    init(workspace: String) {
        self.workspace = URL(filePath: workspace, directoryHint: .isDirectory)
    }

    @discardableResult
    func run(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL? = nil
    ) async throws -> String {
        let location = currentDirectoryURL ?? self.workspace
        // TODO: Add signpost wrapper for each method
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)

        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        // let arguments = ["-C", location.path()]
        // print("arguments \(command)")
        let execPath = Bundle.main.resourcePath ?? "" + "/" + "Executables/git-arm64/git-core"
        let appHome = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true)
        // print("apphome \(appHome.absoluteString)")

        // print(execPath)
        task.environment = [
            // TODO: Support Intel
            "GIT_CONFIG_NOSYSTEM": "true",
            "HOME": appHome.path,
            "GIT_EXEC_PATH": execPath
        ]
        task.launchPath = executable.url.path()
        // task.executableURL = executable.url
        task.qualityOfService = .userInitiated
        task.arguments = command
        task.currentDirectoryURL = location
        return try await withCheckedThrowingContinuation { continuation in
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = (String(data: data, encoding: .utf8) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                // print("output run: \(output)")
                switch process.terminationReason {
                case .uncaughtSignal:
                    let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
                    print("ERROR: \(error.localizedDescription)")
                    self.signposter.endInterval("run", state)
                    continuation.resume(throwing:error)
                case .exit:
                    self.signposter.endInterval("run", state)
                    continuation.resume(returning:output)
                @unknown default:
                    //TODO: theoretically, this ought not to happen
                    self.signposter.endInterval("run", state)

                    continuation.resume(returning:output)
                }
            }

            try! task.run()
            // signposter.endInterval("run", state)
        }
    }
}

extension Bundle {
    func resourceURL(to path: String) -> URL? {
        return URL(string: path, relativeTo: Bundle.main.resourceURL)
    }
}

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }
}
