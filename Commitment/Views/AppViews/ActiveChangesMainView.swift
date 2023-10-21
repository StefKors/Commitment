//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct ActiveChangesMainView: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var viewState: ViewState

//    let id: GitFileStatus?

    var body: some View {
        VStack(spacing: 0) {
            ToolbarContentView()
                .zIndex(999)

            Divider()

            ZStack {
                Rectangle().fill(.clear)
                if let fileStatus = viewState.activeChangesSelection {
                    FileDiffChangesView(fileStatus: fileStatus)
                } else {
                    ContentPlaceholderView()
                }
            }.layoutPriority(1)
        }
    }
}

