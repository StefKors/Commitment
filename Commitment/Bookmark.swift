//
//  Bookmark.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
import SwiftData
import Foundation
import UniformTypeIdentifiers

/// A bookmark object that describes the location of a file.
///
/// Whereas path and file reference URLs are potentially fragile between launches of your app, a bookmark can
/// usually be used to re-create a URL to a file even in cases where the file was moved or renamed.
///
/// Links :-
///
/// [Locating Files Using Bookmarks](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/AccessingFilesandDirectories/AccessingFilesandDirectories.html#//apple_ref/doc/uid/TP40010672-CH3-SW10)
///
/// [Enabling Security-Scoped Bookmark and URL Access](https://developer.apple.com/documentation/professional_video_applications/fcpxml_reference/asset/media-rep/bookmark/enabling_security-scoped_bookmark_and_url_access)
///
/// [Bookmarks and Security Scope](https://developer.apple.com/documentation/foundation/nsurl#1663783)
@available(macOS 10.12, iOS 14, tvOS 14, *)
@Model
class Bookmark: CustomStringConvertible, Codable {
    var repository: CodeRepository?
    enum CodingKeys: CodingKey {
        case bookmarkData
    }

    /// Bookmark-specific errors
    enum BookmarkError: Error {
        case invalidFileURL
        case cantAccessTargetUTType
        case invalidTargetUTType
        case cantAccessSecurityScopedResource
        case bookmarkIsStaleNeedsRebuild
    }

    /// The bookmark's state.
    enum State {
        /// The bookmark is valid (ie. the target url is resolvable)
        case valid
        /// The bookmark needs to be rebuilt (eg. the original target file has been moved or renamed)
        case stale
        /// The targetURL cannot be resolved, and as such the bookmark is invalid
        case invalid
    }

    /// The result of retrieving a URL from a bookmark
    struct TargetURL {
        /// The state of the bookmark
        let state: Bookmark.State
        /// The target URL for the bookmark
        let url: URL
        init(result: Bookmark.State, url: URL) {
            self.state = result
            self.url = url
        }
    }

    /// The raw bookmark data
    let bookmarkData: Data

    /// A base64 string representation for the bookmark data
    var bookmarkBase64: String {
        self.bookmarkData.base64EncodedString()
    }

    /// Returns the bookmark state. If stale, your app should create a new bookmark use it in place of any stored copies
    /// of the existing bookmark.
    ///
    /// If the URL is no longer valid (eg the target file can no longer be found, returns .invalid)
    var state: State {
        guard let state = try? targetURL().state else {
            return .invalid
        }
        return state
    }

    /// Returns true if the bookmark was created with security scope (creation options contained `.withSecurityScope`)
    /// and the target for the bookmark is still resolvable. Returns `nil` if the bookmark is no longer resolvable.
    ///
    /// Note: iOS bookmarks are ALWAYS security scoped.
    var isSecurityScoped: Bool? {
        guard self.state == .invalid else {
            return nil
        }

#if os(macOS)
        guard
            let result = try? targetURL(options: .withSecurityScope),
            result.state != .invalid
        else {
            return false
        }
#endif
        return true
    }

    /// Create a bookmark object from a target file url
    /// - Parameters:
    ///   - targetFileURL: The target file url to bookmark
    ///   - includingResourceValuesForKeys: Resource keys to store in the bookmark
    ///   - options: Bookmark creation options
    init(
        targetFileURL: URL,
        includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
        options: URL.BookmarkCreationOptions = []
    ) throws {
        guard targetFileURL.isFileURL else {
            throw BookmarkError.invalidFileURL
        }

        self.bookmarkData = try targetFileURL.bookmarkData(
            options: options,
            includingResourceValuesForKeys: keys,
            relativeTo: nil
        )
    }

    /// Create a bookmark object from a target file path
    /// - Parameters:
    ///   - targetFilePath: The target file path to bookmark
    ///   - includingResourceValuesForKeys: Resource keys to store in the bookmark
    ///   - options: Bookmark creation options
    @inlinable  convenience init(
        targetFilePath: String,
        includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
        options: URL.BookmarkCreationOptions = []
    ) throws {
        try self.init(
            targetFileURL: URL(fileURLWithPath: targetFilePath),
            includingResourceValuesForKeys: keys,
            options: options
        )
    }

    /// Create a bookmark object from raw bookmark data
    /// - Parameter bookmarkData: The bookmark data
    /// - Parameter validate: Validate the bookmark data is valid and the target url is resolvable.
    init(bookmarkData: Data, validate: Bool = false) throws {
        if validate {
            var isStale = false
            let _ = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
        }
        self.bookmarkData = bookmarkData
    }

    /// Create a bookmark by copying another bookmark
    @inlinable  convenience init(_ bookmark: Bookmark) throws {
        try self.init(bookmarkData: bookmark.bookmarkData)
    }

    /// Create from data within a decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bookmarkData = try container.decode(Data.self, forKey: .bookmarkData)
    }

    /// Encode the bookmark data to an encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.bookmarkData, forKey: .bookmarkData)
    }
}

extension Bookmark {
    /// A textual representation of this instance.
    var description: String {
#if os(macOS)
        if let url = try? targetURL(options: .withSecurityScope) {
            return "Bookmark(🔒): '\(url)'"
        }
#endif
        if let url = try? self.targetURL() {
            return "Bookmark: '\(url)'"
        }
        return "<invalid bookmark>"
    }
}

// MARK: - Accessing the bookmark's target

extension Bookmark {
    /// Returns the bookmark's target url
    /// - Parameters:
    ///   - options: Additional bookmark resolution options (See: [Bookmark Resolution Options](https://developer.apple.com/documentation/foundation/nsurl/bookmarkresolutionoptions)
    /// - Returns: A `TargetURL` object consisting of the bookmark's state and the target url
    @inlinable func targetURL(
        options: NSURL.BookmarkResolutionOptions = []
    ) throws -> TargetURL {
        var isStale = false
        let url = try URL(resolvingBookmarkData: self.bookmarkData, options: options, bookmarkDataIsStale: &isStale)
        return TargetURL(result: isStale ? .stale : .valid, url: url)
    }

    /// Access the bookmark's target url in a block scope
    /// - Parameters:
    ///   - options: Additional bookmark resolution options
    ///   - scopedBlock: The block to perform.
    ///                  If securityScoped is true, the url will automatically be wrapped in
    ///                  `startAccessingSecurityScopedResource` and `stopAccessingSecurityScopedResource`
    /// - Returns: A tuple consisting of the bookmark's state and the `scopedBlock`'s return value
    func usingTargetURL<ReturnType>(
        options: NSURL.BookmarkResolutionOptions = [],
        _ scopedBlock: (URL) -> ReturnType
    ) throws -> (bookmarkState: Bookmark.State, result: ReturnType) {
        let urlResult = try targetURL(options: options)
#if os(macOS)
        let securityScoped = options.contains(.withSecurityScope)
#else
        let securityScoped = true
#endif
        if securityScoped {
            guard urlResult.url.startAccessingSecurityScopedResource() == true else {
                throw BookmarkError.cantAccessSecurityScopedResource
            }
        }
        defer { if securityScoped { urlResult.url.stopAccessingSecurityScopedResource() } }
        return (urlResult.state, scopedBlock(urlResult.url))
    }

    /// Access the bookmark's target url in a block scope
    /// - Parameters:
    ///   - options: Additional bookmark resolution options
    /// - Returns: A tuple consisting of the bookmark's state and the `scopedBlock`'s return value
    func startUsingTargetURL(
        options: NSURL.BookmarkResolutionOptions = []
    ) throws -> URL {
        let urlResult = try targetURL(options: options)
#if os(macOS)
        let securityScoped = options.contains(.withSecurityScope)
#else
        let securityScoped = true
#endif
        if securityScoped {
            guard urlResult.url.startAccessingSecurityScopedResource() == true else {
                throw BookmarkError.cantAccessSecurityScopedResource
            }
        }
        return urlResult.url
    }

    func stopUsingTargetURL(options: NSURL.BookmarkResolutionOptions = []) throws {
        let urlResult = try targetURL(options: options)
#if os(macOS)
        let securityScoped = options.contains(.withSecurityScope)
#else
        let securityScoped = true
#endif
        if securityScoped { urlResult.url.stopAccessingSecurityScopedResource() }
    }
}

// MARK: - UTI/UTType

extension Bookmark {
    /// Returns the UTI for the bookmark's target
    func utiStringForTargetURL() throws -> String {
        let targetURL = try self.targetURL().url
        guard
            let typeString = try targetURL.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
        else {
            throw BookmarkError.cantAccessTargetUTType
        }
        return typeString
    }

    /// Returns the UTI for the bookmark's target
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    func utiForTargetURL() throws -> UTType {
        let utiString = try utiStringForTargetURL()
        guard let t = UTType(utiString) else {
            throw BookmarkError.invalidTargetUTType
        }
        return t
    }
}

// MARK: - Retrieving bookmark resource values

extension Bookmark {
    /// Returns resource values that were stored during bookmark creation
    ///
    /// See: `init(targetFileURL:includingResourceValuesForKeys:options:)`
    @inlinable func resourceValues(forKeys keys: Set<URLResourceKey>) -> URLResourceValues? {
        URL.resourceValues(
            forKeys: keys,
            fromBookmarkData: self.bookmarkData
        )
    }
}

// MARK: - Writing bookmark data

extension Bookmark {
    /// Write the bookmark data to an alias file
    /// - Parameters:
    ///   - fileURL: The file url to write the alias file to
    ///   - options: data writing options (See: [WritingOptions](https://developer.apple.com/documentation/foundation/nsdata/writingoptions))
    ///
    /// Throws `BookmarkError.bookmarkIsStaleNeedsRebuild` if the bookmark is stale and needs rebuilding
    @inlinable func writeBookmarkData(
        to fileURL: URL,
        options: Data.WritingOptions = []
    ) throws {
        assert(fileURL.isFileURL)

        let targetURL = try self.targetURL()

        if targetURL.state == .stale {
            throw BookmarkError.bookmarkIsStaleNeedsRebuild
        }

        try self.bookmarkData.write(to: fileURL, options: options)
    }

    /// Create an alias file.
    /// - Parameters:
    ///   - aliasFileUrl: The location of the alias file to create
    ///   - options: Bookmark creation options (See: [BookmarkCreationOptions](https://developer.apple.com/documentation/foundation/nsurl/bookmarkcreationoptions))
    ///
    /// Throws `BookmarkError.bookmarkIsStaleNeedsRebuild` if the bookmark is stale and needs rebuilding
    func writeAliasFile(
        to aliasFileUrl: URL,
        options: URL.BookmarkCreationOptions
    ) throws {
        assert(aliasFileUrl.isFileURL)

        // Grab out the url for the bookmark
        let targetURL = try self.targetURL()

        if targetURL.state == .stale {
            throw BookmarkError.bookmarkIsStaleNeedsRebuild
        }

        // Make sure we write a suitable bookmark file (a Finder 'alias')
        var options = options
        options.insert(.suitableForBookmarkFile)

        // Create a bookmark with the appropriate flags
        let bookmark = try Bookmark(
            targetFileURL: targetURL.url,
            options: options
        )

        try URL.writeBookmarkData(bookmark.bookmarkData, to: aliasFileUrl)
    }
}

extension Bookmark {
    /// Make a copy of this bookmark
    @inlinable func copy() throws -> Bookmark {
        return try Bookmark(bookmarkData: self.bookmarkData)
    }

    /// Create a new bookmark referencing the same url as this bookmark.
    /// - Parameters:
    ///   - includingResourceValuesForKeys: Resource keys to store in the bookmark
    ///   - options: Bookmark creation options
    /// - Returns: A new bookmark
    ///
    /// Useful when the bookmark is marked as stale by the system
    @inlinable func rebuild(
        includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil,
        options: URL.BookmarkCreationOptions = []
    ) throws -> Bookmark {
        let url = try self.targetURL().url
        return try Bookmark(targetFileURL: url, includingResourceValuesForKeys: keys, options: options)
    }
}
