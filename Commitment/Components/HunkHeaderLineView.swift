//
//  HunkHeaderLineView.swift
//  Commitment
//
//  Created by Stef Kors on 23/02/2023.
//

import SwiftUI


struct HunkHeaderLineNumberButtonView: View {

    var body: some View {
        ZStack(alignment: .center) {

        }
        .frame(width: 60)
        .font(.system(size: 11))
        .foregroundColor(.secondary)
    }
}

struct HunkHeaderLineView: View {
    let header: String
    var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(.separator).frame(height: 1)

            HStack(spacing: 0) {
                HunkHeaderLineNumberButtonView()
                Text(header)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.secondary)
                Spacer()
            }
            .frame(height: 20)
            .background(.background.opacity(0.5))

            Rectangle().fill(.separator).frame(height: 1)
        }
    }
}

struct HunkHeaderLineView_Previews: PreviewProvider {
    static var previews: some View {
        HunkHeaderLineView(header: "@@ -125,9 +120,10 @@ struct CommitmentApp: App {")
    }
}
