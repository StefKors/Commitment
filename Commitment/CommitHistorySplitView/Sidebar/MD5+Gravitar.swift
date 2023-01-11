//
//  MD5+Gravitar.swift
//  Difference
//
//  Created by Stef Kors on 16/08/2022.
//

import Foundation
import CommonCrypto

import Foundation
import AppKit
import CryptoKit

extension String {
    fileprivate var md5Hash: String {
        print(self)
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map {String(format: "%02hhx", $0)}.joined()
    }
    // fileprivate var md5Hash: String {
    //     let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
    //
    //     return digest.map {
    //         String(format: "%02hhx", $0)
    //     }.joined()
    //     // let trimmedString = lowercased().trimmingCharacters(in: .whitespaces)
    //     // let utf8String = trimmedString.cString(using: .utf8)!
    //     // let stringLength = CC_LONG(trimmedString.lengthOfBytes(using: .utf8))
    //     // let digestLength = Int(CC_MD5_DIGEST_LENGTH)
    //     // let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
    //     //
    //     // CC_MD5(utf8String, stringLength, result)
    //     //
    //     // var hash = ""
    //     //
    //     // for i in 0..<digestLength {
    //     //     hash += String(format: "%02x", result[i])
    //     // }
    //     //
    //     // result.deallocate()
    //     //
    //     // return String(format: hash)
    // }
}
//
//
// import Foundation
// import CommonCrypto
//
// extension String {
//     var md5Hash: String {
//         let data = Data(self.utf8)
//         let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
//             var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//             CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
//             return hash
//         }
//         return hash.map { String(format: "%02x", $0) }.joined()
//     }
// }

// MARK: - QueryItemConvertible
private protocol QueryItemConvertible {
    var queryItem: URLQueryItem { get }
}

// MARK: -
public struct Gravatar {
    public enum DefaultImage: String, QueryItemConvertible {
        case http404 = "404"
        case mysteryMan = "mm"
        case identicon
        case monsterID = "monsterid"
        case wavatar
        case retro
        case blank

        var queryItem: URLQueryItem {
            URLQueryItem(name: "d", value: rawValue)
        }
    }

    public enum Rating: String, QueryItemConvertible {
        case g
        case pg
        case r
        case x

        var queryItem: URLQueryItem {
            URLQueryItem(name: "r", value: rawValue)
        }
    }

    public let email: String
    public let forceDefault: Bool
    public let defaultImage: DefaultImage
    public let rating: Rating

    // private static let baseURL = URL(string: "https://secure.gravatar.com/avatar")! // default
    private static let baseURL = URL(string: "http://cdn.libravatar.org/avatar")! // gitlab


    public init(emailAddress: String,
                defaultImage: DefaultImage = .mysteryMan,
                forceDefault: Bool = false,
                rating: Rating = .pg) {
        email = emailAddress
        self.defaultImage = defaultImage
        self.forceDefault = forceDefault
        self.rating = rating
    }

    public func url(size: CGFloat, scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1) -> URL {
        let url = Gravatar.baseURL.appendingPathComponent(email.md5Hash)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        var queryItems = [defaultImage.queryItem, rating.queryItem]
        if forceDefault {
            queryItems.append(URLQueryItem(name: "f", value: "y"))
        }
        queryItems.append(URLQueryItem(name: "s", value: String(format: "%.0f", size * scale)))

        components.queryItems = queryItems
        return components.url!
    }
}
