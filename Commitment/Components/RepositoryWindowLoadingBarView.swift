//
//  RepositoryWindowLoadingBarView.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//

import SwiftUI

struct RepositoryWindowLoadingBarView: View {
    @State private var hasTimeElapsed = false
    
    var body: some View {
        if hasTimeElapsed {
            VStack (alignment: .leading) {
                Text("Failed to setup Repository")
                Text("If this persists please contact the developer")
                    .foregroundStyle(.secondary)
            }
        } else {
            ProgressView("Setting up Repository")
                .progressViewStyle(.linear)
                .frame(maxWidth: 300)
                .task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    hasTimeElapsed = true
                }
        }
    }
}

#Preview {
    RepositoryWindowLoadingBarView()
}
