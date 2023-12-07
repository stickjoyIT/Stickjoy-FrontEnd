//
//  SearchBar.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI
import UIKit

struct SearchBar: View {
    @Binding var searchText:String
    @Binding var amigos:[Amigo]
    @Binding var loagin:Bool
    @State var lenguaje = "es"
    @ObservedObject var uvm = UsuariosViewModel()
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 8)
            
            TextField(lenguaje == "es" ? "Buscar usuarios" : "Search users", text: $searchText, onEditingChanged: { input in
                
            }, onCommit: {
                loagin = false
                if !searchText.isEmpty {
                }
            })
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
                .onChange(of: searchText) { newValue in
                    
                    if !searchText.isEmpty {
                        loagin = true
                        uvm.searchUser(search: searchText){ result in
                            amigos = result
                            loagin = false
                        }
                    } else {
                        loagin = false
                    }
                }
                
            Button(action: {
                searchText = ""
                amigos = []
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            //.opacity(searchText.isEmpty ? 0 : 1)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onTapGesture {
            self.hideKeyboard()
        }
        .onAppear {
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), amigos: .constant([]), loagin: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
