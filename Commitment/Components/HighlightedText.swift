//
//  HighlightedText.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//


import SwiftUI
import Splash

fileprivate struct ThemeHighlightedText: View {
    let highlightedContent: AttributedString
    let theme: Theme = .dark()

    init(_ text: String, theme: Theme = .dark()) {
        do {
            let highlighter = SyntaxHighlighter(
                format: AttributedStringOutputFormat(theme: theme),
                grammar: SwiftGrammar()
            )
            // let html = "<title>hello world</title>"
            // let swift = "func hello() -> String"
            // NSAttributedString
            // let htmlGrammar = try Grammar(textMateFile: Bundle.main.url(forResource: "HTML", withExtension: ".plist")!)
            let content = highlighter.highlight(text)
            let result = try AttributedString(content, including: \.appKit)
            self.highlightedContent = result
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var body: some View {
        Text(highlightedContent)
            .fontDesign(.monospaced)
    }
}

struct HighlightedText: View {
    @Environment(\.colorScheme) private var colorScheme
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        ThemeHighlightedText(text, theme: colorScheme == .light ? .light() : .dark())
    }
}

struct PreviewHighlightEditor: PreviewProvider{
    static var previews: some View{
        HighlightedText("func hello() -> String")
    }
}
