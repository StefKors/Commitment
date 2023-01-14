//
//  CodeRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import Git

import CodeEditTextView

func loadTheme(themeName: String = "codeedit-github-dark") -> EditorTheme? {
    guard let defaultUrl = Bundle.main.url(forResource: themeName, withExtension: "json"),
          let json = try? Data(contentsOf: defaultUrl),
          let theme = try? JSONDecoder().decode(Theme.self, from: json)
    else {
        return nil
    }

    return theme.editor.editorTheme
}

struct CodeRenderView: View {
    internal init(text: String) {
        self.theme = loadTheme()!
        self.text = text
    }

    @State var text: String
    @State var theme: EditorTheme
    @State var font = NSFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    @State var tabWidth = 4
    @State var lineHeight = 1.4
    @State var editorOverscroll = 0.3
    @State var wrapLines = false

    var body: some View {
        CodeEditTextView(
            $text,
            language: .swift,
            theme: $theme,
            font: $font,
            tabWidth: $tabWidth,
            lineHeight: $lineHeight,
            wrapLines: $wrapLines,
            editorOverscroll: $editorOverscroll
        )
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
}

struct CodeRenderView_Previews: PreviewProvider {
    static var previews: some View {
        CodeRenderView(text: "let value: String = \"Content\"")
    }
}
