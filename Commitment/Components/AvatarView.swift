//
//  AvatarView.swift
//  Difference
//
//  Created by Stef Kors on 26/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct AvatarView: View {
    var email: String

    let size: CGFloat = 14

    fileprivate func getAvatar(_ email: String) -> URL? {
        URL(string: "https://avatars.githubusercontent.com/u/e?email=\(email)&s=64")
    }

    var body: some View {
        CachedAsyncImage(
            url: getAvatar(email),
            urlCache: .imageCache,
            transaction: Transaction(animation: .spring())
        ) { phase in
            switch phase {
            case .success(let image):
                ZStack {
                    image
                        .resizable()
                        .clipShape(Circle())
                }
            default:
                ZStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(email: "stef.kors@gmail.com")
    }
}

// URLCache+imageCache.swift
extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
