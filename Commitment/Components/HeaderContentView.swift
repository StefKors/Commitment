//
//  HeaderContentView.swift
//  Commitment
//
//  Created by Stef Kors on 04/02/2023.
//

import SwiftUI

struct HeaderContentView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.repository.folderName)
                    .fontWeight(.bold)
                Text(self.repository.branch?.name.localName ?? "")
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
