//
//  String+DeletePrefix.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//  source: https://www.hackingwithswift.com/example-code/strings/how-to-remove-a-prefix-from-a-string

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
