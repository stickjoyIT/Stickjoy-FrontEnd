//
//  NewFeedHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct FeedHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme

    var body: some View {
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Feed")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Image("stickjoyLogo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(32)
                }
                Text("¡Hi!, \(ProfileInfo.profileUsername)")
                    .font(.headline)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct FeedHeader_Previews: PreviewProvider {
    static var previews: some View {
        FeedHeader()
    }
}
