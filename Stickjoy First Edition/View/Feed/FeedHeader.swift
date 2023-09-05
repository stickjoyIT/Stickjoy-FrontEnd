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
    let nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
    @Binding var lenguaje:String
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
                Text(lenguaje == "es" ? "Hola, @\(nameUser.replacingOccurrences(of: " ", with: ""))!" : "Hi, @\(nameUser.replacingOccurrences(of: " ", with: ""))!")
                    .font(.headline)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct FeedHeader_Previews: PreviewProvider {
    static var previews: some View {
        FeedHeader(lenguaje: .constant("es"))
    }
}
