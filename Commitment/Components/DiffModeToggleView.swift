//
//  DiffModeToggleView.swift
//  Commitment
//
//  Created by Stef Kors on 23/10/2023.
//

import SwiftUI

struct DiffViewModePickerView: View {
    let mode: DiffViewMode
    var body: some View {
        switch mode {
        case .unified:
            Label("Unified", systemImage: "rectangle.split.1x2.fill")
                .help("Unified")
        case .sideBySide:
            Label("Side by Side", systemImage: "rectangle.split.2x1.fill")
                .help("Side by Side")
        }
    }
}

struct DiffModeToggleView: View {
    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified
    
    var body: some View {
        Menu("Diff Options", systemImage: "gear") {
            Section("Diff View Mode") {
                Picker("Tags", selection: $diffViewMode) {
                    ForEach(DiffViewMode.allCases, id: \.self) { tag in
                        DiffViewModePickerView(mode: tag)
                            .tag(tag)
                    }
                }
                .pickerStyle(.palette)
            }
        }
        .menuStyle(.borderlessButton)
        .frame(width: 30)
    }
}

#Preview {
    DiffModeToggleView()
}
