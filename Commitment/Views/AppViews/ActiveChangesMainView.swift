//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct ActiveChangesMainView: View {
    var fileId: GitFileStatus.ID? = nil

    var body: some View {
        if let fileId {
            FileDiffChangesView(fileId: fileId)
        } else {
            ContentPlaceholderView()
        }
    }
}
