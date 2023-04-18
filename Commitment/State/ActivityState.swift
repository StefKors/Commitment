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
    @Published var current: [Activity: Bool] = [
        .isRefreshingState: false,
        .isCommiting: false,
        .isCheckingOutBranch: false,
        .isPushingBranch: false
    ]

    @MainActor func start(_ activity: Activity) {
        current[activity] = true
    }

    @MainActor func finish(_ activity: Activity) {
        current[activity] = false
    }
}
