//
//  ActivityState.swift
//  Commitment
//
//  Created by Stef Kors on 23/02/2023.
//

import SwiftUI

enum Activity {
    case isRefreshingState
    case isCommiting
    case isCheckingOutBranch
    case isPushingBranch
}

class ActivityState: ObservableObject {
    @Published var current: Activity? = nil
    var isPushing: Bool {
        self.current == .isPushingBranch
    }

    @MainActor func start(_ activity: Activity) {
        withAnimation(.spring()) {
            current = activity
        }
    }

    @MainActor func finish(_ activity: Activity) {
        if current == activity {
            withAnimation(.spring()) {
                current = nil
            }
        }
    }
}
