//
//  FileTypeIconView.swift
//  Commitment
//
//  Created by Stef Kors on 16/10/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileTypeIconView: View {
    let path: String
    @Environment(CodeRepository.self) private var repository

    @ScaledMetric private var size = 18

    private var url: URL {
        URL(filePath: path, relativeTo: self.repository.path)
    }

    private var isImage: Bool {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.conforms(to: UTType.image)
        }
        return false
    }

    private var isPbxproj: Bool {
        url.pathExtension == "pbxproj"
    }

    var body: some View {
        Group {
            if isImage {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
            } else if let icon = fileLanguages[url.pathExtension] {
                Image(icon.filename)
//                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.8)
            } else if isPbxproj {
                Image(.pbxprojAlt)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
            } else {
                Image(.defaultFile)
//                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.8)
            }
        }
        .frame(width: size, height: size, alignment: .center)
    }
}

#Preview {
    FileTypeIconView(path: "css")
}
