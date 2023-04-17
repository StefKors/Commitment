//
//  UndoActionView.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct UndoActionView: View {
    let action: UndoAction
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Text("Revert \(action.type.rawValue.capitalized)")
                Text("Revert \(action.arguments.first ?? "")")
                Text("\(action.type.rawValue.capitalized)ed \(action.createdAt.formatted(.relative(presentation: .named)))")
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 20)
            Button("Undo", action: {
                print("Todo: handle undo action")
            })
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
        .background(.background)
        .cornerRadius(4)
        .shadow(color: Color.black.lighter(by: 50).opacity(0.4), radius: 6, y: 3)

    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - (position + 1))
        return self
            .offset(x: 0, y: offset * 6)
            .scaleEffect(x: 1 - (offset / 30))
    }
}

struct UndoActionView_Previews: PreviewProvider {
    static let action: UndoAction = .sample
    static let samples: [UndoAction] = [.sample, .sample, .sample, .sample]

    static var previews: some View {
        UndoActionView(action: action)
            .frame(maxWidth: 250)
            .scenePadding()

        ZStack {
            ForEach(0..<samples.count, id: \.self) { index in
                UndoActionView(action: samples[index])
                    .stacked(at: index, in: samples.count)
            }
        }
        .frame(maxWidth: 250)
        .padding(50)
    }
}
