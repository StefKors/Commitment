//
//  GitDiff.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// Represents a universal git diff
public struct GitDiff: Codable, Equatable {
    public static func == (lhs: GitDiff, rhs: GitDiff) -> Bool {
        return lhs.addedFile == rhs.addedFile &&
        lhs.removedFile == rhs.removedFile &&
        lhs.hunks == rhs.hunks &&
        lhs.lines == rhs.lines
    }
    
    public let addedFile: String
    
    public let removedFile: String
    
    public let hunks: [GitDiffHunk]

    public var lines: [GitDiffHunkLine]

    // Source string of diff
    public let unifiedDiff: String
    
    public init?(unifiedDiff: String) {
        let parsingResults = GitDiffParser(unifiedDiff: unifiedDiff).parse()
        self.init(
            addedFile: parsingResults.addedFile,
            removedFile: parsingResults.removedFile,
            hunks: parsingResults.hunks,
            unifiedDiff: unifiedDiff
        )
    }
    
    internal init(
        addedFile: String,
        removedFile: String,
        hunks: [GitDiffHunk],
        unifiedDiff: String
    ) {
        self.addedFile = addedFile
        self.removedFile = removedFile
        self.hunks = hunks
        self.unifiedDiff = unifiedDiff
        self.lines = hunks.map { hunk in
            hunk.lines
        }.flatMap { $0 }
    }
    
    internal var description: String {
        let header = """
        --- \(removedFile)
        +++ \(addedFile)
        """
        return hunks.reduce(into: header) {
            $0 +=  "\n\($1.description)"
        }
    }
}

extension Collection where Element == GitDiff {
    func fileStatus(for fileId: GitFileStatus.ID?) -> GitDiff? {
        guard let fileId else { return nil }
        // Gets file path while supporting renamed/moved files
        // handles renamed
        guard let filePath = fileId.split(separator: " -> ").last else { return nil }
        let path = String(filePath)
        return self.first { diff in
            return diff.addedFile.contains(path)
        }
    }

    func fileStatus(for status: GitFileStatus?) -> GitDiff? {
        guard let fileId = status?.cleanedPath else { return nil }
        // Gets file path while supporting renamed/moved files
        return self.first { diff in
            return diff.addedFile.contains(fileId)
        }
    }
}

extension GitDiff {
    static let previewVersionBump = GitDiff.Preview.toDiff(GitDiff.Preview.versionBump)!

    struct Preview {
        /// A unified Diff String of a major version bump in a package.json file
        static let versionBump: String = """
diff --git a/package.json b/package.json
index 09ff520..4f245a9 100644
--- a/package.json
+++ b/package.json
@@ -1,6 +1,6 @@
 {
   "name": "playground",
-  "version": "2.0.0",
+  "version": "2.0.1",
   "main": "index.js",
   "license": "MIT",
   "dependencies": {
"""
        /// A unified Diff String of a deleted file
        static let deletedFile: String = """
diff --git a/objs.js b/objs.js
deleted file mode 100644
index c8ecb36..0000000
--- a/objs.js
+++ /dev/null
@@ -1 +0,0 @@
-const sequence = {"time":"2020-08-26T13:17:20.079Z","card":{"active":true,"data":{"mirrors":["https://api.nuc.bob.local/v5/organization(21)"],"translateDate":"2020-08-26T13:17:20.079Z","username":"stef_kors_doggo","billingCode":"prototype-v2","canSelfServe":true,"monthlyPrice":10900,"annualPrice":118800,"generation":4,"plan":"Prototype"},"type":"account@1.0.0","slug":"account-twentyto","name":"twentyto"},"actor":"9e7c113e-0c67-412c-b3bf-c74d24c0b544"}
~
"""
        /// A unified Diff String of an added file
        static let addedFile: String = """
"""

        static let configChanges: String = """
diff --git a/GitLab.xcodeproj/project.pbxproj b/GitLab.xcodeproj/project.pbxproj
index 33f76a1..bf1cde8 100644
--- a/GitLab.xcodeproj/project.pbxproj
+++ b/GitLab.xcodeproj/project.pbxproj
@@ -27,7 +27,7 @@
         8A7935B92A55827600F8FB6C /* Defaults in Frameworks */ = {isa = PBXBuildFile; productRef = 8A7935B82A55827600F8FB6C /* Defaults */; };
         8A7935BC2A55830D00F8FB6C /* CIJobsNotificationView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80D192A55817400819B80 /* CIJobsNotificationView.swift */; };
         8A7935BE2A55830F00F8FB6C /* NotificationViewController.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8A36AF142869B4110008B949 /* NotificationViewController.swift */; };
-        8A7935C02A55837500F8FB6C /* MergeRequests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* MergeRequests.swift */; };
+        8A7935C02A55837500F8FB6C /* Structs.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* Structs.swift */; };
         8A7935C12A5583E400F8FB6C /* NetworkManager+repoLaunchPad.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE02A55817400819B80 /* NetworkManager+repoLaunchPad.swift */; };
         8A7935C22A5583E400F8FB6C /* LaunchpadState.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE12A55817400819B80 /* LaunchpadState.swift */; };
         8A7935C32A5583E400F8FB6C /* PushEvents.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE22A55817400819B80 /* PushEvents.swift */; };
@@ -40,8 +40,6 @@
         8A7935CA2A5583E400F8FB6C /* NetworkManager+fetchProjects.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEA2A55817400819B80 /* NetworkManager+fetchProjects.swift */; };
         8A7935CB2A5583E400F8FB6C /* NetworkManager+fetchAuthoredMergeRequests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEB2A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift */; };
         8A7935CC2A5583E400F8FB6C /* TargetProjects.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEC2A55817400819B80 /* TargetProjects.swift */; };
-        8A7935CD2A5583E400F8FB6C /* UserDefaults.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CED2A55817400819B80 /* UserDefaults.swift */; };
-        8A7935CE2A5583E400F8FB6C /* UserDefaultsFix.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEE2A55817400819B80 /* UserDefaultsFix.swift */; };
         8A7935CF2A5583E400F8FB6C /* NetworkReachability.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEF2A55817400819B80 /* NetworkReachability.swift */; };
         8A7935D02A5583E400F8FB6C /* NoticeMessage.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CF12A55817400819B80 /* NoticeMessage.swift */; };
         8A7935D12A5583E400F8FB6C /* NoticeType.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CF22A55817400819B80 /* NoticeType.swift */; };
@@ -112,8 +110,8 @@
         8AF80D312A55817400819B80 /* NotificationManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE52A55817400819B80 /* NotificationManager.swift */; };
         8AF80D332A55817400819B80 /* NetworkManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE62A55817400819B80 /* NetworkManager.swift */; };
         8AF80D342A55817400819B80 /* NetworkManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE62A55817400819B80 /* NetworkManager.swift */; };
-        8AF80D362A55817400819B80 /* MergeRequests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* MergeRequests.swift */; };
-        8AF80D372A55817400819B80 /* MergeRequests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* MergeRequests.swift */; };
+        8AF80D362A55817400819B80 /* Structs.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* Structs.swift */; };
+        8AF80D372A55817400819B80 /* Structs.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE72A55817400819B80 /* Structs.swift */; };
         8AF80D392A55817400819B80 /* GitLabISO8601DateFormatter.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE82A55817400819B80 /* GitLabISO8601DateFormatter.swift */; };
         8AF80D3A2A55817400819B80 /* GitLabISO8601DateFormatter.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE82A55817400819B80 /* GitLabISO8601DateFormatter.swift */; };
         8AF80D3C2A55817400819B80 /* CachedAsyncImage+ImageCache.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CE92A55817400819B80 /* CachedAsyncImage+ImageCache.swift */; };
@@ -124,10 +122,6 @@
         8AF80D432A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEB2A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift */; };
         8AF80D452A55817400819B80 /* TargetProjects.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEC2A55817400819B80 /* TargetProjects.swift */; };
         8AF80D462A55817400819B80 /* TargetProjects.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEC2A55817400819B80 /* TargetProjects.swift */; };
-        8AF80D482A55817400819B80 /* UserDefaults.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CED2A55817400819B80 /* UserDefaults.swift */; };
-        8AF80D492A55817400819B80 /* UserDefaults.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CED2A55817400819B80 /* UserDefaults.swift */; };
-        8AF80D4B2A55817400819B80 /* UserDefaultsFix.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEE2A55817400819B80 /* UserDefaultsFix.swift */; };
-        8AF80D4C2A55817400819B80 /* UserDefaultsFix.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEE2A55817400819B80 /* UserDefaultsFix.swift */; };
         8AF80D4E2A55817400819B80 /* NetworkReachability.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEF2A55817400819B80 /* NetworkReachability.swift */; };
         8AF80D4F2A55817400819B80 /* NetworkReachability.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CEF2A55817400819B80 /* NetworkReachability.swift */; };
         8AF80D512A55817400819B80 /* NoticeMessage.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AF80CF12A55817400819B80 /* NoticeMessage.swift */; };
@@ -219,6 +213,21 @@
         8AFDAA982A84FB26001937AC /* Account.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAA972A84FB26001937AC /* Account.swift */; };
         8AFDAA992A84FB26001937AC /* Account.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAA972A84FB26001937AC /* Account.swift */; };
         8AFDAA9A2A84FB26001937AC /* Account.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAA972A84FB26001937AC /* Account.swift */; };
+        8AFDAABD2A850763001937AC /* AddAccountView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAABC2A850763001937AC /* AddAccountView.swift */; };
+        8AFDAABE2A850763001937AC /* AddAccountView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAABC2A850763001937AC /* AddAccountView.swift */; };
+        8AFDAABF2A850763001937AC /* AddAccountView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAABC2A850763001937AC /* AddAccountView.swift */; };
+        8AFDAAC12A850784001937AC /* AccountListEmptyView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC02A850784001937AC /* AccountListEmptyView.swift */; };
+        8AFDAAC22A850784001937AC /* AccountListEmptyView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC02A850784001937AC /* AccountListEmptyView.swift */; };
+        8AFDAAC32A850784001937AC /* AccountListEmptyView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC02A850784001937AC /* AccountListEmptyView.swift */; };
+        8AFDAAC52A850793001937AC /* AccountRow.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC42A850793001937AC /* AccountRow.swift */; };
+        8AFDAAC62A850793001937AC /* AccountRow.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC42A850793001937AC /* AccountRow.swift */; };
+        8AFDAAC72A850793001937AC /* AccountRow.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC42A850793001937AC /* AccountRow.swift */; };
+        8AFDAAC92A85112E001937AC /* GitProviderView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC82A85112E001937AC /* GitProviderView.swift */; };
+        8AFDAACA2A85112E001937AC /* GitProviderView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC82A85112E001937AC /* GitProviderView.swift */; };
+        8AFDAACB2A85112E001937AC /* GitProviderView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAAC82A85112E001937AC /* GitProviderView.swift */; };
+        8AFDAACD2A85231F001937AC /* MergeRequest.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAACC2A85231F001937AC /* MergeRequest.swift */; };
+        8AFDAACE2A85231F001937AC /* MergeRequest.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAACC2A85231F001937AC /* MergeRequest.swift */; };
+        8AFDAACF2A85231F001937AC /* MergeRequest.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFDAACC2A85231F001937AC /* MergeRequest.swift */; };
         8AFEF17528E1EE60003F6241 /* MenubarContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 8AFEF17428E1EE60003F6241 /* MenubarContentView.swift */; };
 /* End PBXBuildFile section */

@@ -342,14 +351,12 @@
         8AF80CE42A55817400819B80 /* NetworkManager+fetchReviewRequestedMergeRequests.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "NetworkManager+fetchReviewRequestedMergeRequests.swift"; sourceTree = "<group>"; };
         8AF80CE52A55817400819B80 /* NotificationManager.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = NotificationManager.swift; sourceTree = "<group>"; };
         8AF80CE62A55817400819B80 /* NetworkManager.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = NetworkManager.swift; sourceTree = "<group>"; };
-        8AF80CE72A55817400819B80 /* MergeRequests.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MergeRequests.swift; sourceTree = "<group>"; };
+        8AF80CE72A55817400819B80 /* Structs.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = Structs.swift; sourceTree = "<group>"; };
         8AF80CE82A55817400819B80 /* GitLabISO8601DateFormatter.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = GitLabISO8601DateFormatter.swift; sourceTree = "<group>"; };
         8AF80CE92A55817400819B80 /* CachedAsyncImage+ImageCache.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "CachedAsyncImage+ImageCache.swift"; sourceTree = "<group>"; };
         8AF80CEA2A55817400819B80 /* NetworkManager+fetchProjects.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "NetworkManager+fetchProjects.swift"; sourceTree = "<group>"; };
         8AF80CEB2A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "NetworkManager+fetchAuthoredMergeRequests.swift"; sourceTree = "<group>"; };
         8AF80CEC2A55817400819B80 /* TargetProjects.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = TargetProjects.swift; sourceTree = "<group>"; };
-        8AF80CED2A55817400819B80 /* UserDefaults.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = UserDefaults.swift; sourceTree = "<group>"; };
-        8AF80CEE2A55817400819B80 /* UserDefaultsFix.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = UserDefaultsFix.swift; sourceTree = "<group>"; };
         8AF80CEF2A55817400819B80 /* NetworkReachability.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = NetworkReachability.swift; sourceTree = "<group>"; };
         8AF80CF12A55817400819B80 /* NoticeMessage.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = NoticeMessage.swift; sourceTree = "<group>"; };
         8AF80CF22A55817400819B80 /* NoticeType.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = NoticeType.swift; sourceTree = "<group>"; };
@@ -394,6 +401,11 @@
         8AF80D1F2A55817400819B80 /* MenuBarButtonStyle.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MenuBarButtonStyle.swift; sourceTree = "<group>"; };
         8AF80D202A55817400819B80 /* LaunchpadItem.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = LaunchpadItem.swift; sourceTree = "<group>"; };
         8AFDAA972A84FB26001937AC /* Account.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = Account.swift; sourceTree = "<group>"; };
+        8AFDAABC2A850763001937AC /* AddAccountView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AddAccountView.swift; sourceTree = "<group>"; };
+        8AFDAAC02A850784001937AC /* AccountListEmptyView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AccountListEmptyView.swift; sourceTree = "<group>"; };
+        8AFDAAC42A850793001937AC /* AccountRow.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AccountRow.swift; sourceTree = "<group>"; };
+        8AFDAAC82A85112E001937AC /* GitProviderView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GitProviderView.swift; sourceTree = "<group>"; };
+        8AFDAACC2A85231F001937AC /* MergeRequest.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MergeRequest.swift; sourceTree = "<group>"; };
         8AFEF17428E1EE60003F6241 /* MenubarContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MenubarContentView.swift; sourceTree = "<group>"; };
 /* End PBXFileReference section */

@@ -656,7 +668,7 @@
                 8AF80CE92A55817400819B80 /* CachedAsyncImage+ImageCache.swift */,
                 8AF80CE82A55817400819B80 /* GitLabISO8601DateFormatter.swift */,
                 8AF80CE12A55817400819B80 /* LaunchpadState.swift */,
-                8AF80CE72A55817400819B80 /* MergeRequests.swift */,
+                8AF80CE72A55817400819B80 /* Structs.swift */,
                 8AF80CE62A55817400819B80 /* NetworkManager.swift */,
                 8AF80CEB2A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift */,
                 8AF80CE32A55817400819B80 /* NetworkManager+fetchLatestBranchPush.swift */,
@@ -668,8 +680,6 @@
                 8AF80CE52A55817400819B80 /* NotificationManager.swift */,
                 8AF80CE22A55817400819B80 /* PushEvents.swift */,
                 8AF80CEC2A55817400819B80 /* TargetProjects.swift */,
-                8AF80CED2A55817400819B80 /* UserDefaults.swift */,
-                8AF80CEE2A55817400819B80 /* UserDefaultsFix.swift */,
                 8AC0C2092A5D3D720096772B /* AccessToken.swift */,
             );
             path = Models;
@@ -717,6 +727,8 @@
                 8AF80D0D2A55817400819B80 /* NoticeViews */,
                 8AF80D102A55817400819B80 /* RefreshStatus.swift */,
                 8AF80D112A55817400819B80 /* PipelineView.swift */,
+                8AFDAAC02A850784001937AC /* AccountListEmptyView.swift */,
+                8AFDAAC82A85112E001937AC /* GitProviderView.swift */,
                 8AF80D122A55817400819B80 /* ExpandHitBoxModifier.swift */,
                 8AF80D132A55817400819B80 /* LastUpdateMessageView.swift */,
                 8AF80D142A55817400819B80 /* MergeStatusView.swift */,
@@ -727,11 +739,13 @@
                 8AF80D1A2A55817400819B80 /* TitleWebLink.swift */,
                 8AF80D1B2A55817400819B80 /* LaunchPadView.swift */,
                 8AF80D1C2A55817400819B80 /* WebLink.swift */,
+                8AFDAAC42A850793001937AC /* AccountRow.swift */,
                 8AF80D1D2A55817400819B80 /* CIJobsView.swift */,
                 8AF80D1E2A55817400819B80 /* MergeRequestRowView.swift */,
                 8AF80D1F2A55817400819B80 /* MenuBarButtonStyle.swift */,
                 8AF80D202A55817400819B80 /* LaunchpadItem.swift */,
                 8AC0C20D2A5D51FA0096772B /* TokenInformationView.swift */,
+                8AFDAABC2A850763001937AC /* AddAccountView.swift */,
             );
             path = Views;
             sourceTree = "<group>";
@@ -766,6 +780,7 @@
             isa = PBXGroup;
             children = (
                 8AFDAA972A84FB26001937AC /* Account.swift */,
+                8AFDAACC2A85231F001937AC /* MergeRequest.swift */,
             );
             path = SwiftData;
             sourceTree = "<group>";
@@ -1050,8 +1065,9 @@
                 8AF80DC42A55817400819B80 /* WebLink.swift in Sources */,
                 8AF80D552A55817400819B80 /* NoticeType.swift in Sources */,
                 8AC0C20F2A5D51FA0096772B /* TokenInformationView.swift in Sources */,
+                8AFDAAC22A850784001937AC /* AccountListEmptyView.swift in Sources */,
                 8AF80D792A55817400819B80 /* CIPendingIcon.swift in Sources */,
-                8AF80D372A55817400819B80 /* MergeRequests.swift in Sources */,
+                8AF80D372A55817400819B80 /* Structs.swift in Sources */,
                 8AF80D7F2A55817400819B80 /* ShareMergeRequestIcon.swift in Sources */,
                 8AF80D9A2A55817400819B80 /* AccountSettingsView.swift in Sources */,
                 8AF80D3D2A55817400819B80 /* CachedAsyncImage+ImageCache.swift in Sources */,
@@ -1059,9 +1075,11 @@
                 8AF80DA92A55817400819B80 /* ExpandHitBoxModifier.swift in Sources */,
                 8AF80D432A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift in Sources */,
                 8A31CB3D2866334000C94AC1 /* GitLab_iOSApp.swift in Sources */,
+                8AFDAACA2A85112E001937AC /* GitProviderView.swift in Sources */,
                 8AF80DCD2A55817400819B80 /* MenuBarButtonStyle.swift in Sources */,
                 8AF80DB22A55817400819B80 /* LastUpdateMessagePlaceholderView.swift in Sources */,
                 8AF80D702A55817400819B80 /* CIWaitingForResourceIcon.swift in Sources */,
+                8AFDAABE2A850763001937AC /* AddAccountView.swift in Sources */,
                 8AF80D8B2A55817400819B80 /* CIProgressIcon.swift in Sources */,
                 8AF80D402A55817400819B80 /* NetworkManager+fetchProjects.swift in Sources */,
                 8AF80D9D2A55817400819B80 /* NoticeListView.swift in Sources */,
@@ -1071,7 +1089,6 @@
                 8AF80D342A55817400819B80 /* NetworkManager.swift in Sources */,
                 8AF80D3A2A55817400819B80 /* GitLabISO8601DateFormatter.swift in Sources */,
                 8AF80D312A55817400819B80 /* NotificationManager.swift in Sources */,
-                8AF80D492A55817400819B80 /* UserDefaults.swift in Sources */,
                 8AF80D2B2A55817400819B80 /* NetworkManager+fetchLatestBranchPush.swift in Sources */,
                 8AF80D522A55817400819B80 /* NoticeMessage.swift in Sources */,
                 8AF80DA62A55817400819B80 /* PipelineView.swift in Sources */,
@@ -1082,13 +1099,13 @@
                 8AF80DAC2A55817400819B80 /* LastUpdateMessageView.swift in Sources */,
                 8AF80DC72A55817400819B80 /* CIJobsView.swift in Sources */,
                 8AF80D4F2A55817400819B80 /* NetworkReachability.swift in Sources */,
+                8AFDAACE2A85231F001937AC /* MergeRequest.swift in Sources */,
                 8AF80D732A55817400819B80 /* DiscussionCountIcon.swift in Sources */,
                 8AF80DD02A55817400819B80 /* LaunchpadItem.swift in Sources */,
                 8AF80D942A55817400819B80 /* SettingsView.swift in Sources */,
                 8AF80D852A55817400819B80 /* NeedsReviewIcon.swift in Sources */,
                 8AFDAA992A84FB26001937AC /* Account.swift in Sources */,
                 8AF80D912A55817400819B80 /* BaseTextView.swift in Sources */,
-                8AF80D4C2A55817400819B80 /* UserDefaultsFix.swift in Sources */,
                 8AF80DBE2A55817400819B80 /* TitleWebLink.swift in Sources */,
                 8AF80D882A55817400819B80 /* MergeTrainIcon.swift in Sources */,
                 8AF80D7C2A55817400819B80 /* CIRetryIcon.swift in Sources */,
@@ -1101,6 +1118,7 @@
                 8AF80D8E2A55817400819B80 /* UserInterface.swift in Sources */,
                 8AF80D6D2A55817400819B80 /* CISuccessIcon.swift in Sources */,
                 8AF80D642A55817400819B80 /* CIFailedIcon.swift in Sources */,
+                8AFDAAC62A850793001937AC /* AccountRow.swift in Sources */,
                 8AF80D6A2A55817400819B80 /* ApprovedReviewIcon.swift in Sources */,
                 8AC0C20B2A5D3D720096772B /* AccessToken.swift in Sources */,
             );
@@ -1141,8 +1159,6 @@
                 8A7935CA2A5583E400F8FB6C /* NetworkManager+fetchProjects.swift in Sources */,
                 8A7935CB2A5583E400F8FB6C /* NetworkManager+fetchAuthoredMergeRequests.swift in Sources */,
                 8A7935CC2A5583E400F8FB6C /* TargetProjects.swift in Sources */,
-                8A7935CD2A5583E400F8FB6C /* UserDefaults.swift in Sources */,
-                8A7935CE2A5583E400F8FB6C /* UserDefaultsFix.swift in Sources */,
                 8A7935CF2A5583E400F8FB6C /* NetworkReachability.swift in Sources */,
                 8A7935D02A5583E400F8FB6C /* NoticeMessage.swift in Sources */,
                 8A7935D12A5583E400F8FB6C /* NoticeType.swift in Sources */,
@@ -1151,6 +1167,7 @@
                 8A7935D42A5583E400F8FB6C /* CIManualIcon.swift in Sources */,
                 8ADEBF9F2A83A227007C22CD /* URL.swift in Sources */,
                 8A7935D52A5583E400F8FB6C /* CICanceledIcon.swift in Sources */,
+                8AFDAAC32A850784001937AC /* AccountListEmptyView.swift in Sources */,
                 8A7935D62A5583E400F8FB6C /* CIFailedIcon.swift in Sources */,
                 8A7935D72A5583E400F8FB6C /* CIPreparingIcon.swift in Sources */,
                 8A7935D82A5583E400F8FB6C /* ApprovedReviewIcon.swift in Sources */,
@@ -1159,8 +1176,10 @@
                 8A7935DB2A5583E400F8FB6C /* DiscussionCountIcon.swift in Sources */,
                 8A7935DC2A5583E400F8FB6C /* CIScheduledIcon.swift in Sources */,
                 8A7935DD2A5583E400F8FB6C /* CIPendingIcon.swift in Sources */,
+                8AFDAABF2A850763001937AC /* AddAccountView.swift in Sources */,
                 8A7935DE2A5583E400F8FB6C /* CIRetryIcon.swift in Sources */,
                 8AC0C20C2A5D3D720096772B /* AccessToken.swift in Sources */,
+                8AFDAACB2A85112E001937AC /* GitProviderView.swift in Sources */,
                 8A7935DF2A5583E400F8FB6C /* ShareMergeRequestIcon.swift in Sources */,
                 8A7935E02A5583E400F8FB6C /* CICreatedIcon.swift in Sources */,
                 8A7935E12A5583E400F8FB6C /* NeedsReviewIcon.swift in Sources */,
@@ -1183,13 +1202,15 @@
                 8A7935F22A5583E400F8FB6C /* MergeRequestLabelView.swift in Sources */,
                 8A7935F32A5583E400F8FB6C /* TitleWebLink.swift in Sources */,
                 8A7935F42A5583E400F8FB6C /* LaunchPadView.swift in Sources */,
+                8AFDAACF2A85231F001937AC /* MergeRequest.swift in Sources */,
                 8A7935F52A5583E400F8FB6C /* WebLink.swift in Sources */,
                 8A7935F62A5583E400F8FB6C /* CIJobsView.swift in Sources */,
                 8A7935F72A5583E400F8FB6C /* MergeRequestRowView.swift in Sources */,
                 8A7935F82A5583E400F8FB6C /* MenuBarButtonStyle.swift in Sources */,
                 8A7935F92A5583E400F8FB6C /* LaunchpadItem.swift in Sources */,
+                8AFDAAC72A850793001937AC /* AccountRow.swift in Sources */,
                 8A7935BC2A55830D00F8FB6C /* CIJobsNotificationView.swift in Sources */,
-                8A7935C02A55837500F8FB6C /* MergeRequests.swift in Sources */,
+                8A7935C02A55837500F8FB6C /* Structs.swift in Sources */,
                 8A7935BE2A55830F00F8FB6C /* NotificationViewController.swift in Sources */,
             );
             runOnlyForDeploymentPostprocessing = 0;
@@ -1210,6 +1231,8 @@
                 8AC0C20A2A5D3D720096772B /* AccessToken.swift in Sources */,
                 8AF80DB72A55817400819B80 /* MergeRequestLabelView.swift in Sources */,
                 8AF80DCF2A55817400819B80 /* LaunchpadItem.swift in Sources */,
+                8AFDAAC12A850784001937AC /* AccountListEmptyView.swift in Sources */,
+                8AFDAACD2A85231F001937AC /* MergeRequest.swift in Sources */,
                 8AF80DCC2A55817400819B80 /* MenuBarButtonStyle.swift in Sources */,
                 8AF80D752A55817400819B80 /* CIScheduledIcon.swift in Sources */,
                 8AF80D332A55817400819B80 /* NetworkManager.swift in Sources */,
@@ -1218,12 +1241,12 @@
                 8AF80D392A55817400819B80 /* GitLabISO8601DateFormatter.swift in Sources */,
                 8AF80D2A2A55817400819B80 /* NetworkManager+fetchLatestBranchPush.swift in Sources */,
                 8AF80D782A55817400819B80 /* CIPendingIcon.swift in Sources */,
+                8AFDAAC52A850793001937AC /* AccountRow.swift in Sources */,
                 8AF80DC02A55817400819B80 /* LaunchPadView.swift in Sources */,
-                8AF80D482A55817400819B80 /* UserDefaults.swift in Sources */,
                 8AF80D4E2A55817400819B80 /* NetworkReachability.swift in Sources */,
                 8AFDAA982A84FB26001937AC /* Account.swift in Sources */,
                 8AF80D3F2A55817400819B80 /* NetworkManager+fetchProjects.swift in Sources */,
-                8AF80D4B2A55817400819B80 /* UserDefaultsFix.swift in Sources */,
+                8AFDAABD2A850763001937AC /* AddAccountView.swift in Sources */,
                 8AF80DA82A55817400819B80 /* ExpandHitBoxModifier.swift in Sources */,
                 8AF80D872A55817400819B80 /* MergeTrainIcon.swift in Sources */,
                 8AF80D692A55817400819B80 /* ApprovedReviewIcon.swift in Sources */,
@@ -1248,7 +1271,7 @@
                 8AF80D662A55817400819B80 /* CIPreparingIcon.swift in Sources */,
                 8AF80DA22A55817400819B80 /* RefreshStatus.swift in Sources */,
                 8AF80DBD2A55817400819B80 /* TitleWebLink.swift in Sources */,
-                8AF80D362A55817400819B80 /* MergeRequests.swift in Sources */,
+                8AF80D362A55817400819B80 /* Structs.swift in Sources */,
                 8AF80D6F2A55817400819B80 /* CIWaitingForResourceIcon.swift in Sources */,
                 8A5FC0FA26EFD08E004136AB /* GitLabApp.swift in Sources */,
                 8AF80DB42A55817400819B80 /* CIStatusView.swift in Sources */,
@@ -1256,6 +1279,7 @@
                 8AF80D302A55817400819B80 /* NotificationManager.swift in Sources */,
                 8AF80D9C2A55817400819B80 /* NoticeListView.swift in Sources */,
                 8AF80D542A55817400819B80 /* NoticeType.swift in Sources */,
+                8AFDAAC92A85112E001937AC /* GitProviderView.swift in Sources */,
                 8AF80D452A55817400819B80 /* TargetProjects.swift in Sources */,
                 8AF80D422A55817400819B80 /* NetworkManager+fetchAuthoredMergeRequests.swift in Sources */,
                 8AF80D7E2A55817400819B80 /* ShareMergeRequestIcon.swift in Sources */,
@@ -1495,8 +1519,7 @@
                 CLANG_CXX_LANGUAGE_STANDARD = "gnu++17";
                 CLANG_USE_OPTIMIZATION_PROFILE = YES;
                 CODE_SIGN_ENTITLEMENTS = NotificationContent/NotificationContent.entitlements;
-                CODE_SIGN_IDENTITY = "-";
-                "CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";
+                CODE_SIGN_IDENTITY = "Apple Development";
                 CODE_SIGN_STYLE = Automatic;
                 CURRENT_PROJECT_VERSION = 1;
                 DEAD_CODE_STRIPPING = YES;
@@ -1515,6 +1538,7 @@
                 MARKETING_VERSION = 1.18;
                 PRODUCT_BUNDLE_IDENTIFIER = com.stefkors.GitLab.NotificationContent;
                 PRODUCT_NAME = "$(TARGET_NAME)";
+                PROVISIONING_PROFILE_SPECIFIER = "";
                 SKIP_INSTALL = YES;
                 SWIFT_EMIT_LOC_STRINGS = YES;
                 SWIFT_VERSION = 5.0;
@@ -1527,8 +1551,7 @@
                 CLANG_CXX_LANGUAGE_STANDARD = "gnu++17";
                 CLANG_USE_OPTIMIZATION_PROFILE = YES;
                 CODE_SIGN_ENTITLEMENTS = NotificationContent/NotificationContent.entitlements;
-                CODE_SIGN_IDENTITY = "-";
-                "CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";
+                CODE_SIGN_IDENTITY = "Apple Development";
                 CODE_SIGN_STYLE = Automatic;
                 CURRENT_PROJECT_VERSION = 1;
                 DEAD_CODE_STRIPPING = YES;
@@ -1547,6 +1570,7 @@
                 MARKETING_VERSION = 1.18;
                 PRODUCT_BUNDLE_IDENTIFIER = com.stefkors.GitLab.NotificationContent;
                 PRODUCT_NAME = "$(TARGET_NAME)";
+                PROVISIONING_PROFILE_SPECIFIER = "";
                 SKIP_INSTALL = YES;
                 SWIFT_EMIT_LOC_STRINGS = YES;
                 SWIFT_VERSION = 5.0;
@@ -1686,7 +1710,6 @@
                 CLANG_USE_OPTIMIZATION_PROFILE = YES;
                 CODE_SIGN_ENTITLEMENTS = GitLab/GitLab.entitlements;
                 CODE_SIGN_IDENTITY = "Apple Development";
-                "CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";
                 CODE_SIGN_STYLE = Automatic;
                 COMBINE_HIDPI_IMAGES = YES;
                 CURRENT_PROJECT_VERSION = 1;
@@ -1722,7 +1745,6 @@
                 CLANG_USE_OPTIMIZATION_PROFILE = YES;
                 CODE_SIGN_ENTITLEMENTS = GitLab/GitLab.entitlements;
                 CODE_SIGN_IDENTITY = "Apple Development";
-                "CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";
                 CODE_SIGN_STYLE = Automatic;
                 COMBINE_HIDPI_IMAGES = YES;
                 CURRENT_PROJECT_VERSION = 1;
"""

        static let sideBySideSample: String = """
diff --git a/ColorPicker/ColorPickerApp.swift b/ColorPicker/ColorPickerApp.swift
index 0b3fc7c..3dd217d 100644
--- a/ColorPicker/ColorPickerApp.swift
+++ b/ColorPicker/ColorPickerApp.swift
@@ -19,6 +19,11 @@ import AppKit

     @AppStorage("ColorHistory") var colorHistory: [HistoricalColor] = []
     @AppStorage("showAlpha") var showAlpha: Bool = false
+    @AppStorage("ColorStyle") var colorStyle: ColorStyle = .SwiftUI {
+        didSet {
+            self.refreshRightClickMenu()
+        }
+    }
     @Published var isOn: Bool = true
     @Published var showCode: Bool = false
     @Published var setEffect: Bool = false
@@ -27,11 +32,12 @@ import AppKit
     var statusItem: NSStatusItem?
     var statusBarMenu: NSMenu!

+    let anchor = NSMenuItem(title: "Set Color Style", action: nil, keyEquivalent: "")
+
     var selectedColorLabel: String {
-        showAlpha ? selectedColor.pasteboardTextWithAlpha : selectedColor.pasteboardText
+        selectedColor.pasteboardText(style: self.colorStyle, withAlpha: showAlpha)
     }

-
     var toolbarBG: Color {
         return selectedColor.darker(by: 5)
     }
@@ -85,7 +91,6 @@ import AppKit
         statusItem.button?.action = #selector(self.statusBarButtonClicked(_:))
         statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

-
         statusBarMenu = NSMenu(title: "Status Bar Menu")
         statusBarMenu.delegate = self
         self.statusItem = statusItem
@@ -99,6 +104,13 @@ import AppKit
         pasteboard.setString(content, forType: .rtf)
     }

+    @objc func selectColorStyle(_ sender: NSMenuItem) {
+        if let style = ColorStyle(rawValue: sender.title) {
+            print("selected \\(style)")
+            colorStyle = style
+        }
+    }
+
     @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
         if let event = NSApp.currentEvent,
            event.type == NSEvent.EventType.rightMouseUp {
@@ -124,22 +136,60 @@ import AppKit
         }
     }

-    func rightMouseUp() {
+    func refreshRightClickMenu() {
         statusItem?.menu = nil
         statusBarMenu.items = []

+        let submenu = NSMenu(title: "Set Color Style")
+
+        for style in ColorStyle.allCases {
+            let item = NSMenuItem(
+                title: style.rawValue,
+                action: #selector(self.selectColorStyle),
+                keyEquivalent: ""
+            )
+            item.state = style == self.colorStyle ? .on : .off
+            submenu.addItem(item)
+        }
+
+        // set current item
+        if #available(macOS 14.0, *) {
+            anchor.badge = NSMenuItemBadge(string: self.colorStyle.rawValue)
+        } else {
+            // Fallback on earlier versions
+        }
+        statusBarMenu.addItem(anchor)
+        statusBarMenu.setSubmenu(submenu, for: anchor)
+
+        statusBarMenu.addItem(.separator())

         for color in colorHistory.sorted(by: { $0.createdAt > $1.createdAt }).prefix(12) {
             statusBarMenu.addItem(colorToMenuItem(color.value))
         }
-        statusItem?.menu = statusBarMenu // add menu to button...
+        statusItem?.menu = statusBarMenu
+    }
+
+    func rightMouseUp() {
+        self.refreshRightClickMenu()
         statusItem?.button?.performClick(nil) // ...and click
     }

     func colorToMenuItem(_ color: Color) -> NSMenuItem {
-        let simpleItem = NSMenuItem(title: color.pasteboardText, action: #selector(self.copyToPasteboard), keyEquivalent: "")
-        if let image = NSImage(systemSymbolName: "app.fill",
-                               accessibilityDescription: "A rectangle filled with the selected color.") {
+        let simpleItem = NSMenuItem(
+            title: color.pasteboardText(
+                style: self.colorStyle,
+                withAlpha: self.showAlpha
+            ),
+            action: #selector(
+                self.copyToPasteboard
+            ),
+            keyEquivalent: ""
+        )
+
+        if let image = NSImage(
+            systemSymbolName: "app.fill",
+            accessibilityDescription: "A rectangle filled with the selected color."
+        ) {
             var config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
             config = config.applying(.init(paletteColors: [NSColor(color)]))
             simpleItem.image = image.withSymbolConfiguration(config)
@@ -154,7 +204,7 @@ struct ColorPickerApp: App {

     var body: some Scene {
         WindowGroup {
-                ContentView()
+            ContentView()
                 .environmentObject(appDelegate)
                 .frame(maxWidth: 800)
         }
"""
        static func toDiff(_ unifiedDiff: String) -> GitDiff? {
            return GitDiff(unifiedDiff: unifiedDiff)!
        }
    }
}
