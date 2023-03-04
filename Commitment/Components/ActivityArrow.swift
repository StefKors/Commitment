//
//  ActivityArrow.swift
//  Commitment
//
//  Created by Stef Kors on 04/03/2023.
//

import SwiftUI

struct ActivityArrow: View {
    let isPushingBranch: Bool
    var body: some View {
        ZStack {
            if isPushingBranch {
                Image(systemName: "arrow.2.circlepath")
                    .imageScale(.medium)
                    .rotation(isEnabled: true)
                    .frame(width: 18, height: 18, alignment: .center)
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            } else {
                Image(systemName: "arrow.up")
                    .imageScale(.medium)
                    .frame(width: 18, height: 18, alignment: .center)
                    .transition(.opacity.animation(.easeInOut(duration: 0.1)))
            }
        }
        .contentTransition(.interpolate)
    }
}
struct ActivityArrow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityArrow(isPushingBranch: true)
        ActivityArrow(isPushingBranch: false)
    }
}
