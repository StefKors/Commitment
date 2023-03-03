//
//  Shell+ProcessWithLines.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation

actor ProcessWithLines: ObservableObject {
    private let process: Process
    private let stdin = Pipe()
    private let stdout = Pipe()
    private let stderr = Pipe()
    private var buffer = Data()
    private(set) var lines: AsyncLineSequence<FileHandle.AsyncBytes>?

    init(
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL
    ) {
        self.process = Shell.setup(Process(), executable, command, in: currentDirectoryURL)
        process.standardInput = stdin
        process.standardOutput = stdout
        process.standardError = stderr
        let execPath = Bundle.main.resourcePath ?? "" + "/" + "Executables/git-arm64/git-core"
        let appHome = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true)
        process.environment = [
            // TODO: Support Intel
            "GIT_CONFIG_NOSYSTEM": "true",
            "HOME": appHome.path,
            "GIT_EXEC_PATH": execPath
        ]
        process.launchPath = executable.url.path()
        process.qualityOfService = .userInitiated
        process.currentDirectoryURL = currentDirectoryURL
        process.arguments = command
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
