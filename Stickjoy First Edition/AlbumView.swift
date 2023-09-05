//
//  AlbumView.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Paulo: Esta pantalla es una prueba de como se verían los tabView, sin embargo, al parecer no hay tabviews que sean condicionales, es decir, que si estoy en una pantalla cambian los elementos. 

import SwiftUI

enum AlbumTab: String, CaseIterable {
    case myAlbum
    case privacy
    case upload
    case panel
}

struct AlbumView: View {
    @State private var selectedAlbumTab: AlbumTab = .myAlbum
    @State var listaFotos = [String]()
    var body: some View {
        TabView(selection: $selectedAlbumTab) {
            
            NewAlbumScreen(isEdit:.constant(false), editor: .constant(false), nameAlbum: .constant(""), descripAlbum: .constant(""), id_albumSelected: .constant(""), imgPortadaBind: .constant(""), pickturesList: $listaFotos)
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("My Album")
                }
                .tag(AlbumTab.myAlbum)
            
            AlbumPrivacyScreen()
                .tabItem {
                    Image(systemName: "lock")
                    Text("Privacy")
                }
                .tag(AlbumTab.privacy)
            
            //Poner la pantalla de  subir()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload")
                }
                .tag(AlbumTab.upload)
            
            AdminPanelScreen()
            //Poner la pantalla de admin()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Panel")
                }
                .tag(AlbumTab.panel)
        }
    }
}



struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
