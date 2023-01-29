//
//  AddRepoView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct AddRepoView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        Button(action: appModel.openRepo, label: {
            Label("Add folder", systemImage: "plus.rectangle.on.folder")
        })
        .buttonStyle(.plain)
        .foregroundColor(.secondary)
    }
}

struct AddRepoView_Previews: PreviewProvider {
    static var previews: some View {
        AddRepoView()
    }
}
