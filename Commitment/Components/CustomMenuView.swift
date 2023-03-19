//
//  CustomMenuView.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI

extension HorizontalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            dimension[HorizontalAlignment.center]
        }
    }

    static let custom = HorizontalAlignment(Custom.self)
}

extension VerticalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            dimension[VerticalAlignment.center]
        }
    }

    static let custom = VerticalAlignment(Custom.self)
}

extension Alignment {
    static let custom = Alignment(
        horizontal: .custom,
        vertical: .custom
    )
}


// https://www.fivestars.blog/articles/optional-binding/
struct CustomMenu<Menu: View, Label: View>: View {
    @State private var privateIsExpanded: Bool = false
    var isExpanded: Binding<Bool>?
    @ViewBuilder var menu: () -> Menu
    @ViewBuilder var label: Label

    // No binding
    init(
        @ViewBuilder menu: @escaping () -> Menu,
        @ViewBuilder label: () -> Label
    ) {
        self.init(isExpanded: nil, menu: menu, label: label)
    }

    // With binding
    init(
        isExpanded: Binding<Bool>,
        @ViewBuilder menu: @escaping () -> Menu,
        @ViewBuilder label: () -> Label
    ) {
        self.init(isExpanded: .some(isExpanded), menu: menu, label: label)
    }

    // Private!
    private init(
        isExpanded: Binding<Bool>? = nil,
        @ViewBuilder menu: @escaping () -> Menu,
        @ViewBuilder label: () -> Label
    ) {
        self.isExpanded = isExpanded
        self.menu = menu
        self.label = label()
    }

    var body: some View {
        _CustomMenu(
            isExpanded: isExpanded ?? $privateIsExpanded,
            menu: menu
        ) {
            label
        }
    }
}

// Private!
fileprivate struct _CustomMenu<Label: View, Menu: View>: View {
    @Binding var isExpanded: Bool
    @ViewBuilder var menu: () -> Menu
    @ViewBuilder var label: () -> Label
    @State private var scrollViewContentSize: CGSize = .zero
    @FocusState private var hasFocus: Bool
    @ViewBuilder
    var body: some View {
        label()
            .onTapGesture {
                isExpanded.toggle()
            }
            .focused($hasFocus)
            .overlay(alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
                // TODO: fix custom menuview to support optional views
                Group {
                    if isExpanded {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                menu()
                                    .frame(minWidth: 300)
                                    .buttonStyle(.customButtonStyle)
                            }
                            .background(
                                GeometryReader { geo -> Color in
                                    DispatchQueue.main.async {
                                        scrollViewContentSize = geo.size
                                    }
                                    return Color.clear
                                }
                            )
                            // .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                        }
                        .frame(height: min(scrollViewContentSize.height, 500))
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.thinMaterial)
                                .shadow(color: .black.opacity(0.1),radius: 30, y: 4)
                        )
                        // .background(RoundedRectangle(cornerRadius: 6).fill(.ultraThinMaterial))

                    }
                }
            }
    }
}

struct CustomMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenu(isExpanded: .constant(false)) {
            Button("one", action: { })
            Button("two", action: { })
            Button("three", action: { })
            Button("four", action: { })
        } label: {
            Label(title: {
                Text("label")
            }) {
                Image(systemName: "pencil.and.ruler")
            }
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .scenePadding()
        .previewDisplayName("Menu Closed")

        CustomMenu(isExpanded: .constant(true)) {
            Button("one", action: { })
            Button("two", action: { })
            Button("three", action: { })
            Button("four", action: { })
        } label: {
            Label(title: {
                Text("label")
            }) {
                Image(systemName: "pencil.and.ruler")
            }
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .scenePadding()
        .previewDisplayName("Menu Open")

        VStack {
            CustomMenu(isExpanded: .constant(true)) {
                Button("one", action: { })
                Button("two", action: { })
                Button("three", action: { })
                Button("four", action: { })
            } label: {
                Label(title: {
                    Text("label")
                }) {
                    Image(systemName: "pencil.and.ruler")
                }
            }
            .zIndex(999)

            RoundedRectangle(cornerRadius: 12)
                .fill(.blue)
                .frame(width: 200, height: 300)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .scenePadding()
        .previewDisplayName("Menu Open Overlap test")
    }
}

