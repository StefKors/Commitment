//
//  SplitModeToggleView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import Defaults

struct SplitModeToggleView: View {
    @Default(.windowMode) var modeSelection

    var body: some View {
        Picker("", selection: $modeSelection) {
            ForEach(SplitModeOptions.allCases, id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}
