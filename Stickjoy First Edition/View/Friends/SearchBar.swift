//
//  SearchBar.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 8)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.primary)
                .frame(width: .infinity) // Set the width
                .padding(.horizontal, 8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
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
        SearchBar()
            .previewLayout(.sizeThatFits)
    }
}
