//
//  Int+IsNotZero.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//

import Foundation

extension Int {
    /// Value is zero
    var isZero: Bool {
        self == 0
    }

    /// Value is smaller or larger than zero
    var isNotZero: Bool {
        !(self == 0)
    }
}
