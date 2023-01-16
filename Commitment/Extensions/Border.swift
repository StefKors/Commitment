//
//  Border.swift
//  Commitment
//
//  Created by Stef Kors on 16/01/2023.
//

import SwiftUI

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}
