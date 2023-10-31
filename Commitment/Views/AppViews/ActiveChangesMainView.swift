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

    var fileStatus: GitFileStatus? {
        self.repository.status.first(where: { status in
            status.id == viewState.activeChangeSelection
        })
    }

    var body: some View {

        ZStack(alignment: .top) {
            Rectangle().fill(.clear)

            Group {
                if let fileStatus {
                    FileDiffChangesView(fileStatus: fileStatus)
                } else {
                    ContentPlaceholderView()
                        .padding(.top, 60)
                }
            }

            ToolbarContentView()
                .background(.ultraThinMaterial)

        }.layoutPriority(1)

    }
}

