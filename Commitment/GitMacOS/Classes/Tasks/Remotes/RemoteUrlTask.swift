//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

fileprivate enum RemoteURLOptions: ArgumentConvertible {
    case called(name: String)
    
    func toArguments() -> [String] {
        switch self {
        case .called(let name):
            return ["get-url", "--all", "\(name)"]
        }
    }
}

class RemoteUrlTask: RepositoryTask, TaskRequirable {

    var name: String {
        return "remote"
    }
    
    /// The list of remote names obtained by the operation
    private(set) var remoteUrls = [URL]()
    private(set) var remoteName: String
    
    required init(owner: GitRepository, remoteName: String) {
        self.remoteName = remoteName
        
        super.init(owner: owner, options: [])
        
        add(RemoteURLOptions.called(name: remoteName).toArguments())
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as an operation was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToList(message: output)
        }
        
        // parse URLs
        let remotes = self.output?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
        
        for remoteUrl in remotes ?? [] {
            guard let url = URL(string: String(remoteUrl)) else {
                throw GitError.remoteUnableToList(message: "Can not obtain an URL for remote \(self.remoteName)")
            }
            
            remoteUrls.append(url)
        }
    }
}
