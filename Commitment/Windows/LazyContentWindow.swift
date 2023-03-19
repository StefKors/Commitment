//
//  LazyContentWindow.swift
//  Commitment
//
//  Created by Stef Kors on 16/03/2023.
//

import SwiftUI

struct LazyLoadedView: View {
    let id: String
    @State private var hasLoaded: Bool = false
    var body: some View {
        GroupBox {
            Text(id)
            Text("hasLoaded:\(hasLoaded.description)")
        }
        .overlay(content: {
            if hasLoaded == false {
                ProgressView("is loading")
                    .progressViewStyle(.linear)
                    .background(.background.opacity(0.8))
            }
        })
        .frame(width: 400, height: 50, alignment: .leading)
        .task {
            print("loading \(id)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                withAnimation(.stiffBounce) {
                    hasLoaded = true
                }
            })

        }
    }
}

struct LazyContentWindow: View {
    @State private var profiles: [String] = []
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(profiles, id: \.self) { profile in
                    LazyLoadedView(id: profile)
                    Divider()
                }
            }
        }
        .frame(maxWidth: 400, maxHeight: 600)
        .task {
            profiles = Array(1..<1000).map({ Int in
                return "#\(Int)|\(UUID().uuidString)"
            })
        }
    }
}

struct LazyContentWindow_Previews: PreviewProvider {
    static var previews: some View {
        LazyContentWindow()
    }
}
