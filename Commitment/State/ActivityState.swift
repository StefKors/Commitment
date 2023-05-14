//
//  ActivityState.swift
//  Commitment
//
//  Created by Stef Kors on 23/02/2023.
//

import Foundation

enum Activity {
    case isRefreshingState
    case isCommiting
    case isCheckingOutBranch
    case isPushingBranch
}

class ActivityState: ObservableObject {
    @Published var current: Activity? = nil
    @Published var isPushing = false

    @MainActor func start(_ activity: Activity) {
        isPushing = true
        current = activity
    }

    @MainActor func finish(_ activity: Activity) {
        isPushing = false
        if current == activity {
            current = nil
        }
    }
}
