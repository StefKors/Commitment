//
//  HighlightedText.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//


import SwiftUI

// have a look at: https://github.com/ActuallyTaylor/Firefly?

import SwiftUI
import STTextViewUI
import NeonPlugin
import AppKit

//fileprivate struct ThemeHighlightedText: View {
//    let highlightedContent: AttributedString
//    let theme: Theme = .dark()
//
//    init(_ text: String, theme: Theme = .dark()) {
//        do {
//            let highlighter = SyntaxHighlighter(
//                format: AttributedStringOutputFormat(theme: theme),
//                grammar: SwiftGrammar()
//            )
//            // let html = "<title>hello world</title>"
//            // let swift = "func hello() -> String"
//            // NSAttributedString
//            // let htmlGrammar = try Grammar(textMateFile: Bundle.main.url(forResource: "HTML", withExtension: ".plist")!)
//            let content = highlighter.highlight(text)
//            let result = try AttributedString(content, including: \.appKit)
//            self.highlightedContent = result
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    var body: some View {
//        Text(highlightedContent)
//            .fontDesign(.monospaced)
//    }
//}

struct HighlightedSTTextView: View {
    @Environment(\.colorScheme) private var colorScheme
    let string: String

    init(_ string: String) {
        self.string = string
    }
    @State private var text: AttributedString = ""
    @State private var selection: NSRange?
    var body: some View {
        STTextViewUI.TextView(
            text: $text,
            selection: $selection,
            options: [.wrapLines, .highlightSelectedLine],
            plugins: [NeonPlugin(theme: .commitmentDark, language: .swift)]
        )
        .textViewFont(.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular))
        .textViewRuler(true)
        .onAppear {
            loadContent()
        }
    }


    private func loadContent() {
        // (....)
        self.text = AttributedString(string)
    }
}

struct PreviewHighlightedSTTextView: PreviewProvider{
    static let code: String = """
//
//  FileStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct UndoAction: Identifiable, Equatable {
    let type: UndoActionType
    let arguments: [String]
    let id: UUID = .init()
    let createdAt: Date = .now
    var subtitle: String? = nil

    func test() async -> Int {
        return 12
    }
}

extension Theme {
    public static let commitmentDark = Theme(
        [
            "type": Theme.Value(color: Color(ThemeColors.Dark.lightBlue)),
            "class": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
            "class.system": Theme.Value(color: Color(ThemeColors.Dark.yellow))
        ]
    )
}

struct FileStatsView: View {
    let stats: GitFileStats?

    var count: Int {
        var value = 1
        value += 5
        return value
    }

    var body: some View {
        if let stats {
            HStack(spacing: 8) {
                Text("++\\(stats.insertions)")
                    .foregroundColor(Color("GitHubDiffGreenBright"))
                Divider()
                    .frame(maxHeight: 16)
                Text("--\\(stats.deletions)")
                    .foregroundColor(Color("GitHubDiffRedBright"))
                Divider()
            }
            .fontDesign(.monospaced)
        }
    }
}

struct FileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FileStatsView(stats: GitFileStats("4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"))
    }
}

"""

    static let jsCode: String = """
class Polygon {
  constructor() {
    this.name = 'Polygon';
  }
}

"""
    static var previews: some View{
        HighlightedSTTextView(self.code)
    }
}


///// Create a theme matching my personal light Xcode theme
//static func light(withFont font: Splash.Font = .init(size: 12)) -> Theme {
//    return Theme(
//        font: font,
//        plainTextColor: Color(red: 0.258824, green: 0.258824, blue: 0.258824, alpha: 1),
//        tokenColors: [
//            .keyword: ThemeColors.Light.blue,
//            .type: ThemeColors.Light.red,
//            .call: ThemeColors.Light.blue,
//            .number: ThemeColors.Light.green,
//            .comment: ThemeColors.Light.gray,
//            .property: ThemeColors.Light.yellow,
//            .dotAccess: ThemeColors.Light.blue,
//            .preprocessing: ThemeColors.Light.blue,
//            .string: ThemeColors.Light.blue,
//        ],
//        backgroundColor: Color(red: 1, green: 1, blue: 1, alpha: 1)
//    )
//}
//
///// Create a theme matching my personal dark Xcode theme
//static func dark(withFont font: Splash.Font = .init(size: 12)) -> Theme {
//    return Theme(
//        font: font,
//        plainTextColor: Color(red: 0.850973, green: 0.847061, blue: 0.847059, alpha: 1),
//        tokenColors: [
//            .keyword: ThemeColors.Dark.blue,
//            .type: ThemeColors.Dark.red,
//            .call: ThemeColors.Dark.blue,
//            .number: ThemeColors.Dark.green,
//            .comment: ThemeColors.Dark.gray,
//            .property: ThemeColors.Dark.yellow,
//            .dotAccess: ThemeColors.Dark.green,
//            .preprocessing: ThemeColors.Dark.blue,
//            .string: ThemeColors.Dark.blue,
//        ],
//        backgroundColor: Color(red: 1, green: 1, blue: 1, alpha: 1)
//    )
//}

fileprivate extension Color {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(nsColor: .init(red: red, green: green, blue: blue, alpha: alpha))
    }
}

fileprivate struct ThemeColors {
    struct Light {
        static let lightBlue = NSColor(red: 0.329412, green: 0.580392, blue: 0.792157, alpha: 1)
        static let blue = NSColor(red: 0.20903, green: 0.203855, blue: 0.960848, alpha: 1)
        static let yellow = NSColor(red: 0.928672, green: 0.600593, blue: 0.215507, alpha: 1)
        static let gray = NSColor(red: 0.733333, green: 0.733333, blue: 0.733333, alpha: 0.3)
        static let green = NSColor(red: 0.0856264, green: 0.67766, blue: 0.430812, alpha: 1)
        static let red = NSColor(red: 0.843477, green: 0, blue: 0.303088, alpha: 1)
    }

    struct Dark {
        static let lightBlue = NSColor(red: 0.321569, green: 0.568627, blue: 0.772549, alpha: 1)
        static let blue = NSColor(red: 0.530723, green: 0.54806, blue: 0.972598, alpha: 1)
        static let yellow = NSColor(red: 0.956863, green: 0.694118, blue: 0.247059, alpha: 1)
        static let gray = NSColor(red: 0.423529, green: 0.423529, blue: 0.423529, alpha: 1)
        static let green = NSColor(red: 0.322105, green: 0.709894, blue: 0.521544, alpha: 1)
        static let red = NSColor(red: 0.811211, green: 0.228003, blue: 0.380383, alpha: 1)
    }
}

extension Theme {
//    .keyword: ThemeColors.Light.blue,
//    .type: ThemeColors.Light.red,
//    .call: ThemeColors.Light.blue,
//    .number: ThemeColors.Light.green,
//    .comment: ThemeColors.Light.gray,
//    .property: ThemeColors.Light.yellow,
//    .dotAccess: ThemeColors.Light.blue,
//    .preprocessing: ThemeColors.Light.blue,
//    .string: ThemeColors.Light.blue,

    func test() {
//        return 1 + 1
    }
    public static let commitmentLight = Theme(
        [
            "string": Theme.Value(color: Color(ThemeColors.Light.blue)),
            "number": Theme.Value(color: Color(ThemeColors.Light.green)),

            "keyword": Theme.Value(color: Color(ThemeColors.Light.blue)),
            "include": Theme.Value(color: Color(ThemeColors.Light.blue)),
//            "constructor": Theme.Value(color: Color(.systemPink)),
            "keyword.function": Theme.Value(color: Color(ThemeColors.Light.lightBlue)),
            "keyword.return": Theme.Value(color: Color(ThemeColors.Light.blue)),
            "variable.builtin": Theme.Value(color: Color(ThemeColors.Light.green)),
            "boolean": Theme.Value(color: Color(ThemeColors.Light.green)),

//            "type": Theme.Value(color: Color(ThemeColors.Light.red)),

            "function.call": Theme.Value(color: Color(ThemeColors.Light.lightBlue)),

//            "variable": Theme.Value(color: Color(.systemPink)),
            "property": Theme.Value(color: Color(ThemeColors.Light.yellow)),
            "method": Theme.Value(color: Color(ThemeColors.Light.lightBlue)),
            "parameter": Theme.Value(color: Color(ThemeColors.Light.green)),
            "comment": Theme.Value(color: Color(ThemeColors.Light.gray)),
//            "operator": Theme.Value(color: Color(.systemPink)),
            "result": Theme.Value(color: Color(.systemRed)),
            "+=": Theme.Value(color: Color(.blue)),

                .default: Theme.Value(color: Color(NSColor.textColor), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .regular)))
        ]
    )

    public static let commitmentDark = Theme(
        [
            "type": Theme.Value(color: Color(ThemeColors.Dark.green)),
//            "class": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
            "identifier": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
            "identifier.variable": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
            "variable": Theme.Value(color: Color(ThemeColors.Dark.lightBlue)),
            "keyword": Theme.Value(color: Color(ThemeColors.Dark.blue)),
            "keyword.function": Theme.Value(color: Color(ThemeColors.Dark.red)),
            "async_keyword": Theme.Value(color: Color(ThemeColors.Dark.red)),
            "keyword.async": Theme.Value(color: Color(ThemeColors.Dark.red)),


//            "string": Theme.Value(color: Color(ThemeColors.Dark.blue)),
//            "number": Theme.Value(color: Color(ThemeColors.Dark.green)),
//
//            "include": Theme.Value(color: Color(ThemeColors.Dark.blue)),
            //            "constructor": Theme.Value(color: Color(.systemPink)),
//            "keyword.return": Theme.Value(color: Color(ThemeColors.Dark.blue)),
//            "variable.builtin": Theme.Value(color: Color(ThemeColors.Dark.green)),
//            "boolean": Theme.Value(color: Color(ThemeColors.Dark.green)),

            //            "type": Theme.Value(color: Color(ThemeColors.Dark.red)),

//            "function.call": Theme.Value(color: Color(ThemeColors.Dark.lightBlue)),

            //            "variable": Theme.Value(color: Color(.systemPink)),
//            "property": Theme.Value(color: Color(ThemeColors.Dark.yellow)),
//            "method": Theme.Value(color: Color(ThemeColors.Dark.lightBlue)),
//            "parameter": Theme.Value(color: Color(ThemeColors.Dark.green)),
//            "comment": Theme.Value(color: Color(ThemeColors.Dark.gray)),
            //            "operator": Theme.Value(color: Color(.systemPink)),
//            "result": Theme.Value(color: Color(.systemRed)),
//            "+=": Theme.Value(color: Color(.blue)),

                .default: Theme.Value(color: Color(NSColor.textColor), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .regular)))
        ]
    )
}
