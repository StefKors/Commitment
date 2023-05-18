//
//  ButtonStyleProminent.swift
//  Commitment
//
//  Created by Stef Kors on 07/05/2023.
//

import SwiftUI

struct ProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    @State var isHovering: Bool = false

    static let light1 = Color.selectedContentBackgroundColor.lighter(by: 15)
    static let light2 = Color.selectedContentBackgroundColor.darker(by: 10)
    static let lightF1 = Color.selectedContentBackgroundColor
    static let lightF2 = Color.selectedContentBackgroundColor.darker(by: 5)
    static let lightShadow = Color(red: 0, green: 0, blue: 0, opacity: 0.08)

    static let dark1 = Color.selectedContentBackgroundColor.lighter(by: 15)
    static let dark2 = Color.selectedContentBackgroundColor.darker(by: 10)
    static let darkF1 = Color.selectedContentBackgroundColor
    static let darkF2 = Color.selectedContentBackgroundColor.darker(by: 5)
    static let darkShadow = Color(red: 0.0470743, green: 0.0470467, blue: 0.0549031)

    var hoverOutline: Color {
        if isHovering, isEnabled {
            return .selectedContentBackgroundColor.opacity(0.6)
        } else {
            return Color.clear
        }
    }

    let cornerRadius = 5.0

    var color1: Color {
        if !isEnabled {
            return (Color.selectedContentBackgroundColor).lighter(by: 5)
        }
        return (Color.selectedContentBackgroundColor).lighter(by: 15)
    }

    var color2: Color {
        return (Color.selectedContentBackgroundColor).darker(by: 10)
    }

    var colorF1: Color {
        return (Color.selectedContentBackgroundColor)
    }

    var colorF2: Color {
        return (Color.selectedContentBackgroundColor).darker(by: 5)
    }

    var colorShadow: Color {
        if colorScheme == .light {
            return ProminentButtonStyle.lightShadow
        } else {
            return ProminentButtonStyle.darkShadow
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .environment(\.colorScheme, .dark)
                .foregroundStyle(isEnabled ? Color.primary : Color.disabledControlTextColor)
        }
        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(hoverOutline, lineWidth: 6))
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient:
                            Gradient(colors: [
                                colorF1,
                                colorF2
                            ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    ).stroke(
                        LinearGradient(
                            gradient:
                                Gradient(colors: [
                                    color1,
                                    color2
                                ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
                )
                .brightness(isEnabled ? 0 : 0.2)
                .saturation(isEnabled ? 1 : 0.8)
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .shadow(color: colorShadow, radius: 2, x: 0, y: 1)
        )

        .onHover(perform: { hoverState in
            withAnimation(.easeIn(duration: 0.15)) {
                isHovering = hoverState
            }
        })
        .allowsHitTesting(isEnabled)
    }
}

extension ButtonStyle where Self == ProminentButtonStyle {
    /// Custom Prominent accentColor button style
    static var prominentButtonStyle: ProminentButtonStyle { .init() }
}

struct ButtonStyleProminent_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            HStack {
                Label("Commitment", image: "git-repo-16")
                HStack(spacing: 0) {
                    Image(systemName: "command")
                    Image(systemName: "return")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .imageScale(.small)
            }
        }
        .buttonStyle(.prominentButtonStyle)
        .padding()
        .environment(\.colorScheme, .light)
        .previewDisplayName("Default")

        Button("Click Here! (Dark)", action: {})
            .buttonStyle(.prominentButtonStyle)
            .padding()
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Default")

        Button("Click Here! (Hover)", action: {})
            .buttonStyle(ProminentButtonStyle(isHovering: true))
            .padding()
            .previewDisplayName("Hover")

        Button("Click Here! (Default)", action: {})
            .buttonStyle(.prominentButtonStyle)
            .padding()
            .previewDisplayName("Default")

        Button("Click Here! (Disabled)", action: {})
            .buttonStyle(.prominentButtonStyle)
            .padding()
            .disabled(true)
            .previewDisplayName("Disabled")

        Button("Click Here! (prominent regular)", action: {})
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(false)
            .previewDisplayName("Reg Prominent")
    }
}
