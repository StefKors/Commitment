//
//  AddRepoView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct AddRepoView: View {
    @EnvironmentObject var state: WindowState
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button(action: onClick, label: {
            Label("Add folder", systemImage: "plus.rectangle.on.folder")
        })
        .buttonStyle(.plain)
        .foregroundColor(.secondary)
    }

    func onClick() {
        if let selectedRepo = state.openRepo() {
            openWindow(value: selectedRepo)
        }
    }
}

struct AddRepoView_Previews: PreviewProvider {
    static var previews: some View {
        AddRepoView()
    }
}