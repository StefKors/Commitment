//
//  TouchbarRepoView.swift
//  Commitment
//
//  Created by Stef Kors on 07/05/2023.
//

import SwiftUI

struct TouchbarRepoView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        Label( self.repository.folderName, image: "git-repo-16")
    }
}

struct TouchbarRepoView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarRepoView()
    }
}
