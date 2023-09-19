//
//  SideBySideGutterView.swift
//  Commitment
//
//  Created by Stef Kors on 11/08/2023.
//

import SwiftUI

fileprivate struct Arc: Shape {
    var startA: CGFloat
    var endA: CGFloat
    var startB: CGFloat
    var endB: CGFloat

    let minDistance: CGFloat = 4

    /// Draw a shape that arch between two sides. minDistance is 4
    init(startA: CGFloat, endA: CGFloat, startB: CGFloat, endB: CGFloat) {
        // Always sort A and B end points so start is smaller than end
        // If it's equal set the minDistance
        if startA < endA {
            self.startA = startA
            self.endA = endA
        } else if startA > endA {
            self.startA = endA
            self.endA = startA
        } else {
            self.startA = startA
            self.endA = startA + minDistance
        }

        if startB < endB {
            self.startB = startB
            self.endB = endB
        } else if startB > endB {
            self.startB = endB
            self.endB = startB
        } else {
            self.startB = startB
            self.endB = startB + minDistance
        }
    }

    /// Draw a shape that arch between two sides. minDistance is 4
    init(startA: CGFloat, distanceA: CGFloat, startB: CGFloat, distanceB: CGFloat) {
        self.startA = startA
        self.endA = startA + max(distanceA, minDistance)
        self.startB = startB
        self.endB = startB + max(distanceB, minDistance)
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Offset the curve handles 10% from the center line
        let offset: CGFloat = rect.width / 10

        let pointStartA = CGPoint(x: rect.minX, y: startA)
        let pointEndA = CGPoint(x: rect.minX, y: endA)

        let pointStartB = CGPoint(x: rect.maxX, y: startB)
        let pointEndB = CGPoint(x: rect.maxX, y: endB)

        // Draw A Side
        path.move(to: pointStartA)
        path.addCurve(
            to: pointStartB,
            control1: CGPoint(x: rect.midX-offset, y: startA),
            control2: CGPoint(x: rect.midX+offset, y: startB)
        )

        // Draw B Side
        path.addLine(to: pointEndB)
        path.addCurve(
            to: pointEndA,
            control1: CGPoint(x: rect.midX+offset, y: endB),
            control2: CGPoint(x: rect.midX-offset, y: endA)
        )
        path.addLine(to: pointStartA)
        path.closeSubpath()

        return path
    }
}


struct SideBySideGutterView: View {
    var startA: CGFloat
    var endA: CGFloat
    var startB: CGFloat
    var endB: CGFloat

    /// Draw a shape that arch between two sides.
    init(
        startA: CGFloat,
        endA: CGFloat,
        startB: CGFloat,
        endB: CGFloat
    ) {
        self.startA = startA
        self.endA = endA
        self.startB = startB
        self.endB = endB
    }

    /// Draw a shape that arch between two sides.
    init(
        startA: CGFloat,
        distanceA: CGFloat,
        startB: CGFloat,
        distanceB: CGFloat
    ) {
        self.startA = startA
        self.endA = startA + distanceA
        self.startB = startB
        self.endB = startB + distanceB
    }

    var body: some View {
        Arc(
            startA: startA,
            endA: endA,
            startB: startB,
            endB: endB
        )
        .fill(.foreground.quaternary)
        .foregroundStyle(
            .linearGradient(
                colors: [
                    Color.systemOrange,
                    Color.systemOrange,
                    Color.systemPurple,
                    Color.systemPurple,
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

#Preview {
    VStack {
        SideBySideGutterView(
            startA: 40,
            endA: 90,
            startB: 40,
            endB: 10
        )
        SideBySideGutterView(
            startA: 0,
            distanceA: 0,
            startB: 40,
            distanceB: 60
        )
        SideBySideGutterView(
            startA: 0,
            distanceA: 0,
            startB: 20,
            distanceB: 100
        )
    }
    .frame(width: 50, height: 400)
    .scenePadding()
}
