//
//  StatusState.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import Foundation


class StatusState: ObservableObject {
    @Published var status: GitFileStatusList? = nil
}
