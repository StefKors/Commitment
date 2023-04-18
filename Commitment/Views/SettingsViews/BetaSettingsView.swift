//
//  BetaSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import Boutique

struct BetaSettingsView: View {
    @EnvironmentObject var appModel: AppModel
    @AppStorage("CommitWindow") private var commitWindow: Bool = false

    var body: some View {
        SettingsBox(
            label: "Feature Flags",
            sublabel: "Below is a list of feature flags that enable / disable features that are still experimental. Use at your own risk."
        ) {
            VStack {
                HStack {
                    Text("Global Commit Window")
                    Spacer()

                    Toggle("CommitWindow", isOn: $commitWindow)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
            }.padding(6)
        }
    }
}

struct BetaSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BetaSettingsView()
    }
}
