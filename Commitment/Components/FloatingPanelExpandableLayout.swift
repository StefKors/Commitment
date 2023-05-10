//
//  FloatingPanelExpandableLayout.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//

import SwiftUI

/// This SwiftUI view provides basic modular capability to a `FloatingPanel`.
public struct FloatingPanelExpandableLayout<Toolbar: View, Sidebar: View, Content: View, Footer: View>: View {
    var isSubmitting: Bool = false
    @ViewBuilder let toolbar: () -> Toolbar
    @ViewBuilder let sidebar: () -> Sidebar
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer


    /// The minimum width of the sidebar
    var sidebarWidth: CGFloat = 430.0
    /// The minimum width for both views to show
    var totalWidth: CGFloat = 660.0
    /// The minimum height
    var minHeight: CGFloat = 256.0

    /// Stores the expanded width of the view on toggle
    @State var expandedWidth = 860.0

    /// The minimum height for expanded view
    var minExpandedHeight: CGFloat = 400.0
    /// Stores the expanded height of the view on toggle
    @State var expandedHeight = 400.0

    /// Stores a reference to the parent panel instance
    @Environment(\.floatingPanel) var panel

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // VisualEffectView(material: .sidebar)

                VStack(spacing: 0) {
                    /// Display toolbar and toggle button
                    HStack {
                        toolbar()
                        Spacer(minLength: 12)

                        /// Toggle button
                        Button(action: toggleExpand) {
                            /// Use different SF Symbols to indicate the future state
                            Image(systemName: expanded(for: geo.size.width) ?  "menubar.rectangle" : "uiwindow.split.2x1")
                                .animation(.spring(), value: expanded(for: geo.size.width))
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.secondary)
                    }
                    .padding(16)

                    /// Add a visual cue to separate the sections
                    Divider()

                    /// Display sidebar and content view

                    HSplitView {
                        /// Display the sidebar and center it in a vertical stack to fill in the space
                        VStack {
                            Spacer()
                            /// Set the minimum width to the sidebar width, and the maximum width if expanded to the sidebar width, otherwise set it to the total width
                            sidebar()
                                // .frame(minWidth: sidebarWidth, maxWidth: expanded(for: geo.size.width) ? sidebarWidth : totalWidth)
                            Spacer()
                        }
                        .frame(minWidth: 300, maxWidth: sidebarWidth, maxHeight: .infinity)

                        /// Only show content view if expanded
                        /// Set its frame so it's centered no matter what
                        /// Include the divider in this, since we don't want a divider lying around if there is nothing to divide
                        /// Also attach a move from edge transition
                        if expanded(for: geo.size.width) {
                            VStack {
                                // HStack(spacing: 0) {
                                    content()
                                    // .frame(width: geo.size.width-sidebarWidth)
                                // }
                            }
                            // .transition(.move(edge: .trailing))
                            // .transition(.opacity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .navigationSplitViewStyle(.prominentDetail)
                    // .animation(.spring(), value: expanded(for: geo.size.width))

                    VStack(spacing: 0) {
                        // ProgressView()
                        //     .progressViewStyle(.linear)
                        Divider()
                        footer()
                    }
                    .overlay(alignment: .top, content: {
                        Group {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(.linear)
                            } else {
                                Divider()
                            }
                        }
                            .alignmentGuide(VerticalAlignment.top) { dimentions in
                                dimentions[VerticalAlignment.center]
                            }
                    })
                    .background(.regularMaterial)
                }
            }
        }
        .frame(minWidth: sidebarWidth, minHeight: minHeight)
    }
    /// Since the expanded state of the view based on its current geometry, let's make a function for it.
    func expanded(for width: CGFloat) -> Bool {
        return width >= totalWidth
    }

    /// Toggle the expanded state of the panel
    func toggleExpand() {
        if let panel = panel {
            /// Use the parent panel's frame for reference
            let frame = panel.frame

            /// If expanded, store the expanded width for later use
            if expanded(for: frame.width) {
                expandedWidth = frame.width
            }

            /// If expanded, the new width should be the minimum sidebar width, if not, make it the largest of either the stored expanded width or the total width
            let newWidth = expanded(for: frame.width) ? sidebarWidth : max(expandedWidth, totalWidth)

            let newHeight = frame.height >= minExpandedHeight ? minHeight : max(expandedHeight, minExpandedHeight)

            /// Create a new frame that centers the new width on resize
            let newX = frame.midX-newWidth/2
            let newY = frame.midY-newHeight/2
            let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)

            /// Resize the parent panel. The view should resize itself as a consequence.
            panel.setFrame(newFrame, display: true, animate: true)
        }
    }
}
//
// struct FloatingPanelExpandableLayout_Previews: PreviewProvider {
//     static var previews: some View {
//         FloatingPanelExpandableLayout()
//     }
// }
