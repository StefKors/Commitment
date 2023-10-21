//
//  ToolbarPrimaryActionView.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import SwiftUI

struct ToolbarPrimaryActionView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {

        if self.repository.commitsAhead.count > 0 {
            ToolbarPushOriginActionButtonView()
        } else {
            ToolbarFetchOriginActionView()
        }
    }
}

struct ToolbarPrimaryActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPrimaryActionView()
    }
}
