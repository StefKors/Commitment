//
//  SplitModeToggleView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct SplitModeToggleView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        Picker("", selection: appModel.$windowMode.binding) {
            ForEach(SplitModeOptions.allCases, id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}
