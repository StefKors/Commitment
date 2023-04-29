//
//  OverlayAlignmentView.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI


struct OverlayAlignment<OverlayContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let alignment: Alignment
    let relativePos: UnitPoint
    let extendHorizontally: Bool
    @ViewBuilder var overlayContent: () -> OverlayContent

    func body(content: Content) -> some View {
        content
            .alignmentGuide(alignment.horizontal, computeValue: { $0.width * relativePos.x })
            .alignmentGuide(alignment.vertical, computeValue: { $0.height * relativePos.y })
            .zIndex(99)
            .overlay(alignment: alignment, content: {
                if isPresented {
                    overlayContent()
                        .fixedSize(horizontal: extendHorizontally, vertical: false)
                        .zIndex(999)
                }
            })
    }
}

extension View {
    func overlay<OverlayContent>(
        alignment: Alignment,
        relativePos: UnitPoint = .center,
        extendHorizontally: Bool = false,
        _ overlayContent: @escaping () -> OverlayContent
    ) -> some View where OverlayContent: View {
        modifier(OverlayAlignment(
            isPresented: .constant(true),
            alignment: alignment,
            relativePos: relativePos,
            extendHorizontally: extendHorizontally,
            overlayContent: overlayContent
        ))
    }

    func overlay<OverlayContent>(
        isPresented: Binding<Bool>,
        alignment: Alignment,
        relativePos: UnitPoint = .center,
        extendHorizontally: Bool = false,
        _ overlayContent: @escaping () -> OverlayContent
    ) -> some View where OverlayContent: View {
        modifier(OverlayAlignment(
            isPresented: isPresented,
            alignment: alignment,
            relativePos: relativePos,
            extendHorizontally: extendHorizontally,
            overlayContent: overlayContent
        ))
    }
}

struct OverlayAlignment_Previews: PreviewProvider {
    struct PreviewAnchor: View {
        var body: some View {
            Text("Example")
                .background(.blue)
        }
    }

    struct PreviewList: View {
        var body: some View {
            VStack {
                Button("test first with long title", action: { })
                Button("test", action: { })
                Button("test", action: { })
                Button("test", action: { })
                Button("test last", action: { })
            }
            .background(.yellow)
        }
    }

    static var previews: some View {
        Group {
            PreviewAnchor()
                .overlay(alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
                    PreviewList()
                }
        }
        .frame(width: 200, height: 300)
        .previewLayout(.fixed(width: 200, height: 500))
        .scenePadding()
        .previewDisplayName(".topLeading + .bottomLeading with extendHorizontally: true")

        Group {
            PreviewAnchor()
                .overlay(alignment: .top, relativePos: .bottom) {
                    PreviewList()
                }
        }
        .frame(width: 200, height: 300)
        .previewLayout(.fixed(width: 200, height: 500))
        .scenePadding()
        .previewDisplayName(".top + .bottom")

        Group {
            PreviewAnchor()
                .overlay(alignment: .bottom, relativePos: .top) {
                    PreviewList()
                }
        }
        .frame(width: 200, height: 300)
        .previewLayout(.fixed(width: 200, height: 500))
        .scenePadding()
        .previewDisplayName(".bottom + .top")

        Group {
            PreviewAnchor()
                .overlay(alignment: .bottom, relativePos: .bottom) {
                    PreviewList()
                }
        }
        .frame(width: 200, height: 300)
        .previewLayout(.fixed(width: 200, height: 500))
        .scenePadding()
        .previewDisplayName(".bottom + .bottom")

        Group {
            PreviewAnchor()
                .overlay(alignment: .top, relativePos: .top) {
                    PreviewList()
                }
        }
        .frame(width: 200, height: 300)
        .previewLayout(.fixed(width: 200, height: 500))
        .scenePadding()
        .previewDisplayName(".top + .top")
    }
}
