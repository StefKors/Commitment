//
//  Shell+Run.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation
import OSLog

extension Shell {
    @discardableResult
    func run(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL? = nil
    ) async throws -> String {
        let location = currentDirectoryURL ?? self.workspace
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval("run", id: signpostID)

        let process = Shell.setup(Process(), executable, command, in: location)
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        return try await withCheckedThrowingContinuation { continuation in
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

            try! process.run()
        }
    }
}
