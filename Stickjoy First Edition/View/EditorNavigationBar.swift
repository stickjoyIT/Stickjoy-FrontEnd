//
//  EditorNavigationBar.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct EditorNavigationBar: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Button("Cancel") {
                isPresented = false
            }
            .padding()
            
            Spacer()
            
            Button("Save") {
                isPresented = false
            }
            .padding()
        }
        .font(.body)
        .foregroundColor(.blue)
        .background(.thinMaterial)
        .cornerRadius(32)
        .padding(.horizontal)
    }
}

struct EditorNavigationBar_Previews: PreviewProvider {
    @State static var isPresented = false // Provide a dummy State variable
    
    static var previews: some View {
        EditorNavigationBar(isPresented: $isPresented) // Pass the dummy State variable
    }
}
