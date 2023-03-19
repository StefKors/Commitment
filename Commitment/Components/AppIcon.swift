//
//  AppIcon.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct AppIcon: View {
    private let image: NSImage? = NSImage(named: "AppIcon") //?? NSImage(named: "AppIcon")
    var body: some View {
        if let image {
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
