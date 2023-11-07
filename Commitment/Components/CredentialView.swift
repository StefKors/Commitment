//
//  CredentialView.swift
//  Commitment
//
//  Created by Stef Kors on 06/11/2023.
//

import SwiftUI
import SwiftData


struct CredentialView: View {
    let credential: Credential

    @Environment(\.modelContext) private var modelContext
    @State private var showDelete: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(credential.user)
                        .foregroundColor(.primary)
                    Text(credential.host)
                        .foregroundColor(.secondary)
                }
                Text(String(repeating: "⏺", count: credential.password.count))
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer()
            if showDelete {
                Button(role: .destructive) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        modelContext.delete(credential)
//                        passwords?.values.removeAll { credential in
//                            credential == item
//                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
            } else {
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation(.stiffBounce) {
                            showDelete = true
                        }
                    }
            }
        }.task {
            print(credential.path.absoluteString)
        }
    }
}
//#Preview {
//    CredentialView(item: )
//}
