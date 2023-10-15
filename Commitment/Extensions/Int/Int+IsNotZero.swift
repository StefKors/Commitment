//
//  Int+IsNotZero.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//

import Foundation

extension Int {
    /// Value is smaller or larger than zero
    var isNotZero: Bool {
        !(self == 0)
    }
}
