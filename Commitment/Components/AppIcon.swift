//
//  AppIcon.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        if let image = NSImage(named: "AppIcon-Dark") ?? NSImage(named: "AppIcon") {
            Image(nsImage: image)
                .accentGlow()
        }
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
    }
}
