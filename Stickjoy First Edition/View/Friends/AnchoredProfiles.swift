//
//  AnchoredProfiles.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//

import SwiftUI

struct AnchoredProfiles: View {
    var anchoredprofile: ProfileAnchoredProfiles
    var body: some View {
            CustomVStack {
                Button(action: {
                    //Añadir acción de ir a perfil si se da click
                }) {
                    Image(anchoredprofile.anchoredProfilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 152, height: 152)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer(minLength: 0)
                    Text(anchoredprofile.anchoredProfileName)
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
        FriendsScreen()
    }
}
