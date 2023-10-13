//
//  HeaderContentView.swift
//  Commitment
//
//  Created by Stef Kors on 04/02/2023.
//

import SwiftUI

struct HeaderContentView: View {
    @EnvironmentObject private var repo: CodeRepository

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(repo.folderName)
                    .fontWeight(.bold)
                Text(repo.branch?.name.localName ?? "")
                    .foregroundColor(.secondary)
                    .font(.system(size: 11))
            }
            Spacer()
        }
        .padding(.top, 6)
        .padding(.horizontal, 6)
    }
}

struct HeaderContentView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderContentView()
    }
}
