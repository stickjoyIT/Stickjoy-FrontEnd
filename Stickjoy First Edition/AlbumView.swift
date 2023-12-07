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

@available(iOS 16.0, *)
struct AlbumView: View {
    @State private var selectedAlbumTab: AlbumTab = .myAlbum
    @ObservedObject var avm = AlbumViewModel()
    @ObservedObject var uvm = UsuariosViewModel()
    @State var listaFotos = [pickture]()
    var body: some View {
        TabView(selection: $selectedAlbumTab) {
            
            //NewAlbumScreen(avm: avm, uvm: uvm, isEdit:.constant(false), editor: .constant(false), nameAlbum: .constant(""), descripAlbum: .constant(""), id_albumSelected: .constant(""), imgPortadaBind: .constant(""), pickturesList: $listaFotos, lenguaje: .constant("es"), privacy: .constant(2), proceso: .constant(false), userOwner: "")
                //.tabItem {
                  //  Image(systemName: "photo.on.rectangle")
                    //Text("My Album")
                //}
                //.tag(AlbumTab.myAlbum)
            
            /*AlbumPrivacyScreen(lenguaje: .constant("es"), privacy: .constant(2), id_album: .constant(""))
                .tabItem {
                    Image(systemName: "lock")
                    Text("Privacy")
                }
                .tag(AlbumTab.privacy)*/
            
            //Poner la pantalla de  subir()
                //.tabItem {
                  //  Image(systemName: "square.and.arrow.up")
                    //Text("Upload")
                //}
                //.tag(AlbumTab.upload)
            
            AdminPanelScreen(avm:AlbumViewModel(), uvm: UsuariosViewModel(), id_album: .constant(""), lenguaje: .constant("es"))
            //Poner la pantalla de admin()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Panel")
                }
                .tag(AlbumTab.panel)
        }
    }
}



@available(iOS 16.0, *)
struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
