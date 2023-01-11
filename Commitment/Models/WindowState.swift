//
//  WindowState.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import Foundation

class WindowState: ObservableObject {
    var repo: Repo

    init (_ repo: Repo) {
        self.repo = repo
    }
}
