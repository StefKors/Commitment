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
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map {String(format: "%02hhx", $0)}.joined()
    }
}

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
