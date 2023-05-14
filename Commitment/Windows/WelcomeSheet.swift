//
//  WelcomeSheet.swift
//  Commitment
//
//  Created by Stef Kors on 20/03/2023.
//

import SwiftUI

struct WelcomeSheet: View {
    @State private var isPresented: Bool = false

    var body: some View {
        HStack {
            EmptyView()
        }
            .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            .onAppear() {
                // print("appear")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    isPresented = true
                })
            }
            .sheet(isPresented: $isPresented) {
                WelcomeWindow()
                    .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            }
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
    }
}
