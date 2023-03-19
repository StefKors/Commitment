//
//  GitReferenceName.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
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

struct GitReferenceName: RepositoryReferenceName, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }

    var path: String
    
    var fullName: String {
        return nameFormattedFullName()
    }
    
    var lastName: String {
        return nameFormattedLastName()
    }
    
    var shortName: String {
        return nameFormattedShortName(includingRemoteName: true)
    }
    
    var remoteName: String {
        return nameFormattedRemote()
    }
    
    var localName: String {
        return nameFormattedShortName(includingRemoteName: false)
    }
}

// MARK: - CustomStringConvertible
extension GitReferenceName: CustomStringConvertible {
    
    var description: String {
        return "\(fullName)"
    }
}

// MARK: - Private
fileprivate extension GitReferenceName {
    
    typealias RefPath = GitReference.RefPath
    
    func dropFirstPathComponent(from path: String) -> String {
        return path.components(separatedBy: RefPath.Separator).dropFirst().joined(separator: RefPath.Separator)
    }
    
    func dropPathComponent(_ component: String, from path: String) -> String {
        let index = path.index(path.startIndex, offsetBy: component.count)
        return String(path[index...]).trimmingCharacters(in: RefPath.SeparatorCharacterSet)
    }
    
    func nameFormattedFullName() -> String {
        let path = path.trimmingCharacters(in: RefPath.SeparatorCharacterSet)
        return path.starts(with: RefPath.Refs) ? dropPathComponent(RefPath.Refs, from: path) : path
    }
    
    func nameFormattedLastName() -> String {
        let components = fullName.components(separatedBy: RefPath.Separator)
        
        guard let lastComponent = components.last, lastComponent.count > 1 else {
            return ""
        }
        
        return lastComponent.trimmingCharacters(in: RefPath.SeparatorCharacterSet)
    }
    
    func nameFormattedShortName(includingRemoteName: Bool) -> String {
        var numberOfPaths = 1
        if !includingRemoteName, path.contains(RefPath.Remotes) {
            numberOfPaths = 2
        }
        
        let components = fullName.components(separatedBy: RefPath.Separator).dropFirst(numberOfPaths)
        
        if components.count == 0 {
            return nameFormattedLastName()
        }
        
        return components.joined(separator: RefPath.Separator).trimmingCharacters(in: RefPath.SeparatorCharacterSet)
    }
    
    func nameFormattedRemote() -> String {
        if path.starts(with: RefPath.Remotes) {
            let path = dropPathComponent(RefPath.Remotes, from: path)
            return path.components(separatedBy: RefPath.Separator).first ?? ""
        }
        
        return ""
    }
}


