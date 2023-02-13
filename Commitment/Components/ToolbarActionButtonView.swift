//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI

struct ToolbarActionButtonView: View {
    private let num = 5
    var body: some View {
        Button(action: handleButton, label: {
            HStack {
                Image(systemName: "arrow.up")
                    .imageScale(.small)
                Text("Push origin")
                    .fontWeight(.bold)
                Text("\(num) commits ahead")
                    .foregroundColor(.secondary)
            }
            .font(.system(size: 10))
            .foregroundColor(.primary)
        })
    }

    func handleButton() {
        print("TODO: primary repo action")
    }
}

struct ToolbarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarActionButtonView()
    }
}
