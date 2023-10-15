//
//  Environment+ActiveRepositoryID.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//

import SwiftUI

private struct ActiveRepositoryID: EnvironmentKey {
    static let defaultValue: Binding<URL?> = .constant(nil)
}

extension EnvironmentValues {
    var activeRepositoryID: Binding<URL?> {
        get { self[ActiveRepositoryID.self] }
        set { self[ActiveRepositoryID.self] = newValue }
    }
}

extension View {
    func activeRepositoryID(_ activeRepositoryID: Binding<URL?>) -> some View {
        environment(\.activeRepositoryID, activeRepositoryID)
    }
}
