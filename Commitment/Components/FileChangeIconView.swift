//
//  FileChangeIconView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

enum FileChangeRenderStyle {
    case both
    case leading
    case trailing
}

struct CombinedFileChangeBackground: ViewModifier {
    let style: FileChangeRenderStyle

    @ScaledMetric private var radius: Double = 2
    @ScaledMetric private var size = 14

    private var shape: some Shape {
        switch style {
        case .both:
            return UnevenRoundedRectangle(
                topLeadingRadius: radius,
                bottomLeadingRadius: radius,
                bottomTrailingRadius: radius,
                topTrailingRadius: radius,
                style: .continuous
            )
        case .leading:
            return UnevenRoundedRectangle(
                topLeadingRadius: radius,
                bottomLeadingRadius: radius,
                bottomTrailingRadius: 0,
                topTrailingRadius: 0,
                style: .continuous
            )
        case .trailing:
            return UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: radius,
                topTrailingRadius: radius,
                style: .continuous
            )
        }
    }

    var tintImage: Bool {
        switch style {
        case .leading :
            return true
        default:
            return false
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            if style == .leading {
                shape
            }

            shape.stroke(lineWidth: 1)
                .foregroundStyle(.primary)

            content
                .foregroundStyle(tintImage ? .secondary : .primary)
        }
        .foregroundStyle(tintImage ? .primary : .secondary)
        .frame(width: size, height: size, alignment: .center)
    }
}

extension View {
    func fileChangeBackground(style: FileChangeRenderStyle) -> some View {
        modifier(CombinedFileChangeBackground(style: style))
    }
}

struct FileStateIconsView: View {
    let state: GitFileStatusState

    // TODO: ignore more states?
    private var isDoubleIcon: Bool {
        (state.worktree != state.index) && (state.worktree != .unmodified)
    }

    var body: some View {
        Group {
            if isDoubleIcon {
                HStack(spacing: 0) {
                    FileChangeIconView(type: state.index, style: .leading)
                    FileChangeIconView(type: state.worktree, style: .trailing)
                }
            } else {
                FileChangeIconView(type: state.index, style: .both)
            }
        }
        .fontWeight(.medium)
    }
}

#Preview {
    VStack {
        FileStateIconsView(state: GitFileStatusState(index: .added, worktree: .modified))
            .scenePadding()

        FileStateIconsView(state: GitFileStatusState(index: .modified, worktree: .modified))
            .scenePadding()

        FileStateIconsView(state: GitFileStatusState(index: .deleted, worktree: .deleted))
            .scenePadding()

        FileStateIconsView(state: GitFileStatusState(index: .added, worktree: .added))
            .scenePadding()
    }
    .scenePadding()
}

fileprivate struct FileChangeIconView: View {
    let type: GitFileStatusModificationState
    var style: FileChangeRenderStyle = .both

    var body: some View {
        HStack {
            switch type {
            case .modified:
                Text("M")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.blue, .background)
            case .added:
                Image(systemName: "plus")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.green, .background)
            case .deleted:
                Image(systemName: "minus")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.red, .background)
            case .renamed:
                Text("R")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.primary, .background)
            case .copied:
                Text("C")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.primary, .background)
            case .untracked:
                Image(systemName: "square.dashed")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.primary, .background)
            case .ignored:
                Image(systemName: "dot.square")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.secondary, .clear)
            case .unmerged:
                Text("M")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.secondary, .clear)
            case .unmodified:
                Image(systemName: "dot.square")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.orange, .background)
            case .unknown:
                Text("?")
                    .fileChangeBackground(style: style)
                    .foregroundStyle(.primary, .background)
            }
        }
        .font(.caption)
        .textCase(.uppercase)
        .symbolVariant(.none)
        .help(type.rawValue)
    }
}

struct FileChangeIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FileChangeIconView(type:.modified)
            FileChangeIconView(type:.added)
            FileChangeIconView(type:.deleted)
            FileChangeIconView(type:.renamed)
            FileChangeIconView(type:.copied)
            FileChangeIconView(type:.untracked)
            FileChangeIconView(type:.ignored)
            FileChangeIconView(type:.unmerged)
            FileChangeIconView(type:.unmodified)
            FileChangeIconView(type:.unknown)
        }
        .scenePadding()

    }
}
