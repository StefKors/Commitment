//
//  CodeView.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit
import Cocoa
import Runestone
import TreeSitterJavaScriptRunestone
import TreeSitterSwiftRunestone

final class BasicCharacterPair: CharacterPair {
    let leading: String
    let trailing: String

    init(leading: String, trailing: String) {
        self.leading = leading
        self.trailing = trailing
    }
}


struct RunestoneCodeView: NSViewRepresentable {
    private let theme: EditorTheme = TomorrowNightTheme()
    private let textView: TextView = {
        let this = TextView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.textContainerInset = NSEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        this.showLineNumbers = true
        this.showTabs = false
        this.showSpaces = false
        this.showLineBreaks = false
        this.showSoftLineBreaks = false
        this.lineHeightMultiplier = 1.3
        this.kern = 0.3
        this.lineSelectionDisplayType = .line
        this.gutterLeadingPadding = 4
        this.gutterTrailingPadding = 4
        this.isLineWrappingEnabled = true
        this.indentStrategy = .space(length: 2)
        this.characterPairs = [
            BasicCharacterPair(leading: "(", trailing: ")"),
            BasicCharacterPair(leading: "{", trailing: "}"),
            BasicCharacterPair(leading: "[", trailing: "]"),
            BasicCharacterPair(leading: "\"", trailing: "\""),
            BasicCharacterPair(leading: "'", trailing: "'")
        ]
        return this
    }()

    var text = """
    func run(_ command: String) async throws -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        return try await withCheckedThrowingContinuation { continuation in
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""

                switch process.terminationReason {
                case .uncaughtSignal:
                    let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
                    continuation.resume(throwing:error)
                case .exit:
                    continuation.resume(returning:output)
                @unknown default:
                    //TODO: theoretically, this ought not to happen
                    continuation.resume(returning:output)
                }
            }
            do {
                try task.run()
            } catch {
                continuation.resume(throwing:error)
            }
        }
    }

    @discardableResult
    func run(_ command: String, in folderPath: String) async throws -> String {
        try await self.run("cd folderPath;command")
    }

    @discardableResult
    func run(_ command: String, in folderPath: String) -> String {
        self.run("cd folderPath;command")
"""

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> TextView {
        let state = TextViewState(text: text, theme: theme, language: .swift)
        textView.setState(state)
        applyTheme(theme)
        return textView
    }

    func updateNSView(_ nsView: TextView, context: Context) {
        let state = TextViewState(text: text, theme: theme, language: .swift)
        nsView.setState(state)
    }

    private func applyTheme(_ theme: EditorTheme) {
        textView.theme = theme
        textView.wantsLayer = true
        textView.layer?.backgroundColor = theme.backgroundColor.cgColor
        textView.insertionPointColor = theme.textColor
        textView.selectionHighlightColor = theme.textColor.withAlphaComponent(0.2)
    }

    class Coordinator: NSObject {
        var codeView: RunestoneCodeView

        init(_ codeView: RunestoneCodeView) {
            self.codeView = codeView
        }
    }
}


struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        RunestoneCodeView()
    }
}
