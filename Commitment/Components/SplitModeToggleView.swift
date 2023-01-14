//
//  SplitModeToggleView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct SplitModeToggleView: View {
    @Binding var modeSelection: SplitModeOptions

    var body: some View {
        Picker("", selection: $modeSelection) {
            ForEach(SplitModeOptions.allCases, id: \.self) { option in
                Text(option.rawValue)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct SplitModeToggleView_Previews: PreviewProvider {
    static var previews: some View {
        SplitModeToggleView(modeSelection: .constant(.changes))
        SplitModeToggleView(modeSelection: .constant(.history))
    }
}
