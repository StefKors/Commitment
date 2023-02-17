//
//  Theme+Light+Dark.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//

import Foundation
import Splash
import AppKit
import SwiftUI

fileprivate struct ThemeColors {
    struct Light {
        static let blue = Color(red: 0.20903, green: 0.203855, blue: 0.960848, alpha: 1)
        static let yellow = Color(red: 0.928672, green: 0.600593, blue: 0.215507, alpha: 1)
        static let gray = Color(red: 0.733333, green: 0.733333, blue: 0.733333, alpha: 1)
        static let green = Color(red: 0.0856264, green: 0.67766, blue: 0.430812, alpha: 1)
        static let red = Color(red: 0.843477, green: 0, blue: 0.303088, alpha: 1)
    }

    struct Dark {
        static let blue = Color(red: 0.530723, green: 0.54806, blue: 0.972598, alpha: 1)
        static let yellow = Color(red: 0.93652, green: 0.678999, blue: 0.246877, alpha: 1)
        static let gray = Color(red: 0.423529, green: 0.423529, blue: 0.423529, alpha: 1)
        static let green = Color(red: 0.322105, green: 0.709894, blue: 0.521544, alpha: 1)
        static let red = Color(red: 0.811211, green: 0.228003, blue: 0.380383, alpha: 1)
    }
}

public extension Theme {
    /// Create a theme matching my personal light Xcode theme
    static func light(withFont font: Splash.Font = .init(size: 14)) -> Theme {
        return Theme(
            font: .init(size: 14),
            plainTextColor: Color(red: 0.258824, green: 0.258824, blue: 0.258824, alpha: 1),
            tokenColors: [
                .keyword: ThemeColors.Light.blue,
                .type: ThemeColors.Light.red,
                .call: ThemeColors.Light.blue,
                .number: ThemeColors.Light.green,
                .comment: ThemeColors.Light.gray,
                .property: ThemeColors.Light.yellow,
                .dotAccess: ThemeColors.Light.blue,
                .preprocessing: ThemeColors.Light.blue,
                .string: ThemeColors.Light.blue,
            ],
            backgroundColor: Color(red: 1, green: 1, blue: 1, alpha: 1)
        )
    }

    /// Create a theme matching my personal dark Xcode theme
    static func dark(withFont font: Splash.Font = .init(size: 14)) -> Theme {
        return Theme(
            font: .init(size: 14),
            plainTextColor: Color(red: 0.850973, green: 0.847061, blue: 0.847059, alpha: 1),
            tokenColors: [
                .keyword: ThemeColors.Dark.blue,
                .type: ThemeColors.Dark.red,
                .call: ThemeColors.Dark.blue,
                .number: ThemeColors.Dark.green,
                .comment: ThemeColors.Dark.gray,
                .property: ThemeColors.Dark.yellow,
                .dotAccess: ThemeColors.Dark.green,
                .preprocessing: ThemeColors.Dark.blue,
                .string: ThemeColors.Dark.blue,
            ],
            backgroundColor: Color(red: 1, green: 1, blue: 1, alpha: 1)
        )
    }
}

struct PreviewTheme: PreviewProvider{
    static let content: String = """
//
//  Theme+Light.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//

import Foundation
import Splash
import AppKit

fileprivate struct ThemeColors {
    struct Light {
        static let blue = Color(red: 0.20903, green: 0.203855, blue: 0.960848, alpha: 1)
        static let yellow = Color(red: 0.928672, green: 0.600593, blue: 0.215507, alpha: 1)
    }
}

public extension Theme {
    /// Create a theme matching the "Sundell's Colors" Xcode theme
    static func light(withFont font: Font = .init(size: 14)) -> Theme {
        return Theme(
            font: .init(size: 14),
            plainTextColor: Color(
                red: 0.66,
                green: 0.74,
                blue: 0.74, alpha: 1
            ),
            tokenColors: [
                .keyword: Color(red: 0.397279, green: 0.406536, blue: 0.428652, alpha: 1),
                .string: Color(red: 0.98, green: 0.39, blue: 0.12, alpha: 1),
                .type: Color(red: 0.843477, green: 0, blue: 0.303088, alpha: 1),
                .number: ThemeColors.Light.green,
            ],
            backgroundColor: Color(
                red: 0.117647,
                green: 0.117647,
                blue: 0.117647,
                alpha: 1
            )
        )
    }
}

struct FileRenderView: View {
    @EnvironmentObject private var repo: RepoState

    var fileStatus: GitFileStatus

    @State private var lines: [GitDiffHunkLine] = []
    @State private var path: String = ""
    @State private var content: String = ""

    var body: some View {
        ZStack {
            Circle()
        }
        FileView(fileStatus: fileStatus) {
                if let lines {
                    ForEach(lines) { line in
                        DiffLineView(line: line)
                            .id(line.id)
                    }
                } else {
                    Text("Could not read file at path")
                }
        }
        .id(fileStatus.path)
        .task(priority: .background) {
            self.path = String(fileStatus.path.split(separator: " -> ").last ?? "")
            self.lines = repo.shell.show(file: path, defaultType: fileStatus.diffModificationState)
            self.content = repo.shell.cat(file: path)
        }
    }
}

"""

    static var previews: some View {
        HStack(alignment: .top) {
            HighlightedText(content)
        }
        .frame(width: 800, height: 1400)
    }
}
