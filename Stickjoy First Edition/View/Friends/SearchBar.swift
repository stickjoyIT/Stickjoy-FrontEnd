//
//  SearchBar.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText:String
    @Binding var amigos:[Amigo]
    @Binding var loagin:Bool
    
    @ObservedObject var uvm = UsuariosViewModel()
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 8)
            
            TextField("Search", text: $searchText, onEditingChanged: { input in
                
            }, onCommit: {
                loagin = true
                uvm.searchUser(search: searchText){ result in
                    amigos = result
                    loagin = false
                }
            })
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
                
            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), amigos: .constant([]), loagin: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
