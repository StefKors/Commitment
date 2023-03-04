//
//  OutputLine.swift
//  Commitment
//
//  Created by Stef Kors on 04/03/2023.
//

import SwiftUI

struct OutputLine: View {
    let output: String?
    let date: Date?
    var body: some View {
        if let output {
            Text(output)
                .lineLimit(1)
                .foregroundColor(.secondary)
                .contentTransition(.interpolate)
                .animation(.easeIn(duration: 0.35), value: output)
        } else {
            if let date {
                Group {
                    Text("Last fetched ") + Text(date, format:
                            .relative(presentation: .named))
                }.foregroundColor(.secondary)
            }
        }
    }
}

struct OutputLine_Previews: PreviewProvider {
    static var previews: some View {
        OutputLine(output: nil, date: .now.advanced(by: -60))
    }
}
