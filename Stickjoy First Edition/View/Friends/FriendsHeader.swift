//
//  NewFriendsHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct FriendsHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    
    @Binding var textSearch:String
    
    @Binding var amigos:[Amigo]
    
    @Binding var loading:Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white) // Ensure the ZStack has a background color
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Amigos")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Image("stickjoyLogo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(32)
                }
                //Este archivo esta en: View/Friends/SearchBar.swift
                SearchBar(searchText: $textSearch, amigos: $amigos, loagin: $loading)
            }
            .padding(24)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
    }
}

struct FriendsHeader_Previews: PreviewProvider {
    static var previews: some View {
        FriendsHeader(textSearch: .constant(""),amigos: .constant([]), loading: .constant(false))
    }
}

