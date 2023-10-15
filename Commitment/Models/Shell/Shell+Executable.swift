//
//  Shell+Executable.swift
//  Commitment
//
//  Created by Stef Kors on 03/03/2023.
//

import Foundation

enum Executable: String {
    case git

    var url: URL {
        Bundle.main.url(forResource: self.rawValue, withExtension: "")!
    }
}
