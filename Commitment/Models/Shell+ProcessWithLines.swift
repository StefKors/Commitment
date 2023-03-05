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
        let task = Shell.setup(Process(), executable, command, in: currentDirectoryURL)
        task.standardInput = stdin
        task.standardOutput = stdout
        task.standardError = stderr
        self.process = task
    }

    func start() throws {
        lines = stdout.fileHandleForReading.bytes.lines
        try process.run()
    }

    func terminate() {
        process.terminate()
    }

    func send(_ string: String) {
        print("send? \(string)")
        guard let data = "\(string)\n".data(using: .utf8) else { return }
        stdin.fileHandleForWriting.write(data)
    }
}
