//
//  WelcomeListItem.swift
//  Commitment
//
//  Created by Stef Kors on 14/10/2023.
//

import SwiftUI

struct WelcomeListItem: View {
    var label: String
    var subLabel: String
    var systemImage: String? = nil
    var assetImage: String? = nil

    @State private var isHovering: Bool = false

    var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(Font.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 25)
            } else if let assetImage {
                Image(assetImage)
                    .font(Font.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 25)
            }

            VStack(alignment: .leading) {
                Text(label)
                Text(subLabel)
                    .foregroundColor(.secondary)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.background)
                .shadow(radius: 5)
                .opacity(isHovering ? 1 : 0)
        )
        .offset(y: isHovering ? -3 : 0)
        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.2), value: isHovering)
        .onHover(perform: { hoverstate in
            isHovering = hoverstate
        })
    }
}


struct WelcomeRepoListView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: setup previews
        WelcomeRepoListView()
    }
}
