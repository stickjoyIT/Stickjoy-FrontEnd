//
//  AnchoredProfiles.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnchoredProfiles: View {
    var anchoredprofile: Amigo
    var body: some View {
            VStack {
                AnimatedImage(url: URL(string: anchoredprofile.user_url))
                    .resizable()
                    .indicator(SDWebImageActivityIndicator.medium)
                    .placeholder(UIImage(named: "stickjoyLogoBlue"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 152, height: 152)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer(minLength: 0)
                    Text(anchoredprofile.name)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 152, alignment: .leading)
                }
            }
        .padding(.bottom, 8)
    }
}

// Custom VStack to control alignment and spacing
struct CustomVStack<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            VStack(alignment: .leading, spacing: 0, content: content)
        } else {
            content()
        }
    }
}

struct AnchoredProfiles_Previews: PreviewProvider {
    static var previews: some View {
        AnchoredProfiles(anchoredprofile: Amigo(user_id: "", name: "Ignacio tun moo", username: "@ignacios", user_url: "https://firebasestorage.googleapis.com:443/v0/b/stickjoy-swiftui.appspot.com/o/AJVuYmOk0AUCNNuMY9le%2FIMG_0672.heic?alt=media&token=c9bd3a54-09f5-46c1-91c6-b0ad37a4c8c0", album_id: "", album_name: "", album_description: "", album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
    }
}
