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

@MainActor
class Shell: ObservableObject {
    @Published var output: String? = nil

    var workspace: URL

    var process: Process = .init()
    var isRunning: Bool {
        process.isRunning
    }

    // Create a signposter that uses the default subsystem and category.
    internal let signposter = OSSignposter()

    init(workspace: String) {
        self.workspace = URL(filePath: workspace, directoryHint: .isDirectory)
    }

    convenience init(workspace: URL) {
        self.init(workspace: workspace.path())
    }

    static func setup(
        _ process: Process,
        _ executable: Executable,
        _ command: [String],
        in currentDirectoryURL: URL
    ) -> Process {
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

        process.environment = envConfig
        process.launchPath = executable.url.path()
        process.qualityOfService = .userInitiated
        process.arguments = command
        process.currentDirectoryURL = currentDirectoryURL
        return process
    }
}

extension Data {
    var toShellOutput: String {
        (String(data: self, encoding: .utf8) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Bundle {
    func resourceURL(to path: String) -> URL? {
        return URL(string: path, relativeTo: Bundle.main.resourceURL)
    }
}

extension String {
    var lines: [String] {
        self.components(separatedBy: "\n")
    }
}
