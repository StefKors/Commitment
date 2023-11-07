//
//  Credential.swift
//  Commitment
//
//  Created by Stef Kors on 06/11/2023.
//

import Foundation
import SwiftData

@Model final class Credential: Identifiable {
    @Attribute(.unique, .allowsCloudEncryption) let path: URL

    init(path: URL) {
        self.path = path
    }

    var id: String {
        self.path.absoluteString
    }

    var password: String {
        self.path.password ?? ""
    }
    var user: String {
        self.path.user ?? ""
    }
    var host: String {
        self.path.host ?? ""
    }
}
