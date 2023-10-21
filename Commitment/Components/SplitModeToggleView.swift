//
//  SplitModeToggleView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct SplitModeToggleView: View {
    @Bindable var repository: CodeRepository

    var body: some View {
        Picker("", selection: $repository.windowMode) {
            ForEach(SplitModeOptions.allCases, id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}
