//
//  EmptyProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//

import SwiftUI

struct DefaultProfileBody: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: {
                // Add your action here
            }) {
                Text("Create Album")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 200)
                    .padding(24)
                    .background(Color.accentColor)
                // Use accent color for adaptive color scheme
                    .cornerRadius(24)
            }
            Spacer()
        }
    }
}

struct DefaultProfileBody_Previews: PreviewProvider {
    static var previews: some View {
        DefaultProfileBody()
            .preferredColorScheme(.dark) // Preview with dark color scheme
    }
}
