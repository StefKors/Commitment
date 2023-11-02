//
//  OpenRepository.swift
//  Commitment
//
//  Created by Stef Kors on 02/11/2023.
//

import Foundation
import SwiftUI

// The reason we use a struct to wrap the action (like Apple does with its own types)
// is because of performance issues when passing functions directly into the environment.
// https://twitter.com/lukeredpath/status/1491127803328495618
struct OpenRepository {
    let action: (CodeRepository) -> Void

    init(_ action: @escaping (CodeRepository) -> Void) {
        self.action = action
    }

    func callAsFunction(_ repo: CodeRepository) {
        action(repo)
    }
}

private struct OpenRepositoryEnvironmentKey: EnvironmentKey {
    static let defaultValue = OpenRepository({ _ in })
}
extension EnvironmentValues {
    var openRepository: OpenRepository {
        get { self[OpenRepositoryEnvironmentKey.self] }
        set { self[OpenRepositoryEnvironmentKey.self] = newValue }
    }
}
