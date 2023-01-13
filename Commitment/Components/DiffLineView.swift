//
//  DiffLineView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

struct DiffLineView: View {
    let line: GitDiffHunkLine
    private let image: String?
    private let color: Color
    
    init(line: GitDiffHunkLine) {
        self.line = line
        
        switch line.type {
        case .addition:
            self.image = "plus"
            self.color = Color("DiffGreen")
        case .deletion:
            self.image = "minus"
            self.color = Color("DiffRed")
        case .unchanged:
            self.image = nil
            self.color = .clear
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .center) {
                color
                if let oldNumber = line.oldLineNumber {
                    Text(oldNumber.description)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))
            .foregroundColor(.secondary)
            
            ZStack(alignment: .center) {
                color
                if let newNumber = line.newLineNumber {
                    Text(newNumber.description)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))
            .foregroundColor(.secondary)

            // Divider()

            ZStack(alignment: .center) {
                color.opacity(0.8)
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))
            
            ZStack(alignment: .leading) {
                color.opacity(0.8)
                Text(line.text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}

struct DiffLineView_Previews: PreviewProvider {
    static var previews: some View {
        DiffLineView(line: GitDiffHunkLine.Preview.deletion)

        DiffLineView(line: GitDiffHunkLine.Preview.addition)

        DiffLineView(line: GitDiffHunkLine.Preview.unchanged)
    }
}
