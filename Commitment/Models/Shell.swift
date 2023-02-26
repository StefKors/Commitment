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

    var url: URL {
        Bundle.main.url(forResource: self.rawValue, withExtension: "")!
    }
}

class Shell {
    var workspace: String

    // Create a signposter that uses the default subsystem and category.
    private let signposter = OSSignposter()

    init(workspace: String) {
        self.workspace = workspace
    }

    @discardableResult
    func run(
        _ executable: Executable,
        _ command: String,
        in currentDirectoryURL: URL? = nil
    ) async throws -> String {
        let location = currentDirectoryURL ?? URL(filePath: self.workspace, directoryHint: .isDirectory)
        // TODO: Add signpost wrapper for each method
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)

        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        // task.launchPath = git.absoluteString
        task.executableURL = executable.url
        task.arguments = [command]
        task.currentDirectoryURL = location
        return try await withCheckedThrowingContinuation { continuation in
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = (String(data: data, encoding: .utf8) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                print("output: \(output) \(process.terminationReason.rawValue)")
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
            do {
                try task.run()
            } catch {
                signposter.endInterval("run", state)
                fatalError(error.localizedDescription)
                continuation.resume(throwing:error)
            }
        }
    }
}

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }
}
