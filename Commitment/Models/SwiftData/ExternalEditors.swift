//
//  ExternalEditors.swift
//  Commitment
//
//  Created by Stef Kors on 05/03/2023.
//

import Foundation

/**
 * This list contains all the external editors supported on macOS. Add a new
 * entry here to add support for your favorite editor.
 * source: github.com/desktop/desktop
 **/
struct ExternalEditor: Equatable, Hashable {
    let name: String
    let bundleIdentifiers: [String]

    let uuid: String

    init(name: String, bundleIdentifiers: [String]) {
        self.name = name
        self.bundleIdentifiers = bundleIdentifiers
        self.uuid = UUID().uuidString
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(uuid)
        hasher.combine(bundleIdentifiers)
    }
}

extension ExternalEditor: Identifiable {
    var id: String {
        self.name
    }
}

extension ExternalEditor: Codable {
    enum CodingKeys: CodingKey {
        case name
        case bundleIdentifiers
        case uuid
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.bundleIdentifiers = try container.decode([String].self, forKey: .bundleIdentifiers)
        self.uuid = try container.decode(String.self, forKey: .uuid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.bundleIdentifiers, forKey: .bundleIdentifiers)
        try container.encode(self.uuid, forKey: .uuid)
    }
}

extension ExternalEditor: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(ExternalEditor.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct ExternalEditors: Codable {
    // default
    static var xcode = ExternalEditor(
        name: "Xcode",
        bundleIdentifiers: ["com.apple.dt.Xcode"]
    )

    var editors: [ExternalEditor] = [
        ExternalEditor(
            name: "Atom",
            bundleIdentifiers: ["com.github.atom"]
        ),
        ExternalEditor(
            name: "Aptana Studio",
            bundleIdentifiers: ["aptana.studio"]
        ),
        ExternalEditor(
            name: "MacVim",
            bundleIdentifiers: ["org.vim.MacVim"]
        ),
        ExternalEditor(
            name: "Neovide",
            bundleIdentifiers: ["com.neovide.neovide"]
        ),
        ExternalEditor(
            name: "Visual Studio Code",
            bundleIdentifiers: ["com.microsoft.VSCode"]
        ),
        ExternalEditor(
            name: "Visual Studio Code (Insiders)",
            bundleIdentifiers: ["com.microsoft.VSCodeInsiders"]
        ),
        ExternalEditor(
            name: "VSCodium",
            bundleIdentifiers: ["com.visualstudio.code.oss", "com.vscodium"]
        ),
        ExternalEditor(
            name: "Sublime Text",
            bundleIdentifiers: [
                "com.subli)etext.4",
                "com.sublimetext.3",
                "com.sublimetext.2",
            ]
        ),
        ExternalEditor(
            name: "BBEdit",
            bundleIdentifiers: ["com.barebones.bbedit"]
        ),
        ExternalEditor(
            name: "PhpStorm",
            bundleIdentifiers: ["com.jetbrains.PhpStorm"]
        ),
        ExternalEditor(
            name: "PyCharm",
            bundleIdentifiers: ["com.jetbrains.PyCharm"]
        ),
        ExternalEditor(
            name: "PyCharm Community Edition",
            bundleIdentifiers: ["com.jetbrains.pycharm.ce"]
        ),
        ExternalEditor(
            name: "DataSpell",
            bundleIdentifiers: ["com.jetbrains.DataSpell"]
        ),
        ExternalEditor(
            name: "RubyMine",
            bundleIdentifiers: ["com.jetbrains.RubyMine"]
        ),
        ExternalEditor(
            name: "RStudio",
            bundleIdentifiers: ["org.rstudio.RStudio"]
        ),
        ExternalEditor(
            name: "TextMate",
            bundleIdentifiers: ["com.macromates.TextMate"]
        ),
        ExternalEditor(
            name: "Brackets",
            bundleIdentifiers: ["io.brackets.appshell"]
        ),
        ExternalEditor(
            name: "WebStorm",
            bundleIdentifiers: ["com.jetbrains.WebStorm"]
        ),
        ExternalEditor(
            name: "CLion",
            bundleIdentifiers: ["com.jetbrains.CLion"]
        ),
        ExternalEditor(
            name: "Typora",
            bundleIdentifiers: ["abnerworks.Typora"]
        ),
        ExternalEditor(
            name: "CodeRunner",
            bundleIdentifiers: ["com.krill.CodeRunner"]
        ),
        ExternalEditor(
            name: "SlickEdit",
            bundleIdentifiers: [
                "com.slick)dit.SlickEditPro2018",
                "com.slickedit.SlickEditPro2017",
                "com.slickedit.SlickEditPro2016",
                "com.slickedit.SlickEditPro2015",
            ]
        ),
        ExternalEditor(
            name: "IntelliJ",
            bundleIdentifiers: ["com.jetbrains.intellij"]
        ),
        ExternalEditor(
            name: "IntelliJ Community Edition",
            bundleIdentifiers: ["com.jetbrains.intellij.ce"]
        ),
        ExternalEditor(
            name: "Xcode",
            bundleIdentifiers: ["com.apple.dt.Xcode"]
        ),
        ExternalEditor(
            name: "GoLand",
            bundleIdentifiers: ["com.jetbrains.goland"]
        ),
        ExternalEditor(
            name: "Android Studio",
            bundleIdentifiers: ["com.google.android.studio"]
        ),
        ExternalEditor(
            name: "Rider",
            bundleIdentifiers: ["com.jetbrains.rider"]
        ),
        ExternalEditor(
            name: "Nova",
            bundleIdentifiers: ["com.panic.Nova"]
        ),
        ExternalEditor(
            name: "Emacs",
            bundleIdentifiers: ["org.gnu.Emacs"]
        ),
        ExternalEditor(
            name: "Lite XL",
            bundleIdentifiers: ["com.lite-xl"]
        ),
        ExternalEditor(
            name: "Fleet",
            bundleIdentifiers: ["Fleet.app"]
        ),
    ]
}
