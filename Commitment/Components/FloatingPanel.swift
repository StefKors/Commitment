//
//  FloatingPanel.swift
//  Commitment
//
//  Created by Stef Kors on 29/04/2023.
//

import SwiftUI

// https://cindori.com/developer/floating-panel
// https://cindori.com/developer/searchable-floating-panel
// https://cindori.com/developer/expandable-floating-panel
/// An NSPanel subclass that implements floating panel traits.
class FloatingPanel<Content: View>: NSPanel {
    @Binding var isPresented: Bool

    init(view: () -> Content,
         contentRect: NSRect,
         backing: NSWindow.BackingStoreType = .buffered,
         defer flag: Bool = false,
         isPresented: Binding<Bool>) {
        /// Initialize the binding variable by assigning the whole value via an underscore
        self._isPresented = isPresented

        /// Init the window as usual
        super.init(contentRect: .zero,
                   styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
                   backing: backing,
                   defer: flag)

        /// Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .floating
        isOpaque = false
        backgroundColor = NSColor.clear
        /// Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior.insert(.fullScreenAuxiliary)

        /// Don't show a window title, even if it's set
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        /// Since there is no title bar make the window moveable by dragging on the background
        isMovableByWindowBackground = true

        /// Keep showing when unfocused
        hidesOnDeactivate = false

        /// Hide all traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        /// Sets animations accordingly
        animationBehavior = .utilityWindow

        /// Set the content view.
        /// The safe area is ignored because the title bar still interferes with the geometry
        contentView = NSHostingView(rootView:
                                        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            view()
        }
            .ignoresSafeArea()
            .environment(\.floatingPanel, self)
        )

    }

    /// Close automatically when out of focus, e.g. outside click
    override func resignMain() {
        super.resignMain()
        close()
    }

    /// Close and toggle presentation, so that it matches the current state of the panel
    override func close() {
        super.close()
        isPresented = false
    }

    /// `canBecomeKey` and `canBecomeMain` are both required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}

private struct FloatingPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
    var floatingPanel: NSPanel? {
        get { self[FloatingPanelKey.self] }
        set { self[FloatingPanelKey.self] = newValue }
    }
}

/// Add a  ``FloatingPanel`` to a view hierarchy
fileprivate struct FloatingPanelModifier<PanelContent: View>: ViewModifier {
    /// Determines wheter the panel should be presented or not
    @Binding var isPresented: Bool

    /// Determines the starting size of the panel
    var contentRect: CGRect

    /// Holds the panel content's view closure
    @ViewBuilder let view: () -> PanelContent

    /// Stores the panel instance with the same generic type as the view closure
    @State var panel: FloatingPanel<PanelContent>?

    func body(content: Content) -> some View {
        content
            .task {
                /// When the view appears, create, center and present the panel if ordered
                panel = FloatingPanel(view: view, contentRect: contentRect, isPresented: $isPresented)
                panel?.center()
                if isPresented {
                    present()
                }
            }.onDisappear {
                /// When the view disappears, close and kill the panel
                panel?.close()
                panel = nil
            }.onChange(of: isPresented) { value in
                /// On change of the presentation state, make the panel react accordingly
                if value {
                    present()
                } else {
                    panel?.close()
                }
            }
    }

    /// Present the panel and make it the key window
    func present() {
        panel?.orderFront(nil)
        panel?.makeKey()
    }
}

extension View {
    /** Present a ``FloatingPanel`` in SwiftUI fashion
     - Parameter isPresented: A boolean binding that keeps track of the panel's presentation state
     - Parameter contentRect: The initial content frame of the window
     - Parameter content: The displayed content
     **/
    func floatingPanel<Content: View>(isPresented: Binding<Bool>,
                                      contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512),
                                      @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FloatingPanelModifier(isPresented: isPresented, contentRect: contentRect, view: content))
    }
}


struct FloatingPanelDemoView: View {
    @State var showingPanel = false

    var body: some View {
        Button("Present panel") {
            showingPanel.toggle()
        }
        .floatingPanel(isPresented: $showingPanel, content: {
            Text("I'm a floating panel. Click anywhere to dismiss me.")
        })
    }
}
