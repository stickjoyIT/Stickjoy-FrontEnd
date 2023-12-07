//
//  ListoScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 29/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListoScreen: View {
    @Binding var shouldPopToRootView : Bool
    @State var lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    @State var cantidad = 0
    @Binding var album_up:String
    @Binding var porcentaje:Float
    @State var ver_album = false
    var albumSelection:AlbumSelectView
    @Binding var isUpload:Bool
    @Binding var isDetailV:Bool
    @Binding var isComplete:Bool
    @State var avm = AlbumViewModel()
    @State var uvm = UsuariosViewModel()
    @State var editor = false
    var body: some View {
        VStack {
            
            Text(lenguaje == "es" ? "Subiste \(cantidad) elementos a tu álbum" : "You uploaded \(cantidad) elements to the following album")
            
            HStack {
                WebImage(url: URL(string: albumSelection.url))
                        .resizable()
                        .placeholder(Image("stickjoyLogo"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                Text(albumSelection.name)
                    .font(.headline)
                Spacer()
                Button (lenguaje == "es" ? "Ver" : "See it"){
                    ver_album = true
                }
            }
            .padding(.horizontal)
            
            Button(lenguaje == "es" ? "Cerrar" : "Close"){
                UserDefaults.standard.set(false, forKey: "uploading")
                shouldPopToRootView = false
                album_up = ""
                porcentaje = 0.0
                isUpload = false
                isDetailV = false
                isComplete = false
                UserDefaults.standard.set("", forKey: "album_update")
            }
            .foregroundColor(.red)
        }
        .fullScreenCover(isPresented: $ver_album, content: {
            NewAlbumScreen(avm: avm, uvm: uvm, isEdit: .constant(false), editor: $editor, nameAlbum: .constant(albumSelection.name), descripAlbum: .constant(albumSelection.descrip), id_albumSelected: .constant(albumSelection.id_album), imgPortadaBind: .constant(albumSelection.url), pickturesList: .constant(avm.picktureList), lenguaje: $lenguaje, privacy: .constant(0), proceso: .constant(false), userOwner: albumSelection.userName, items_up: .constant(0), album_up: .constant(""), rootIsActive: .constant(false), isUploadN: .constant(false), porcentaje: .constant(0), isActive: $ver_album, seeIt: .constant(true))
        })
        .onAppear {
            cantidad = UserDefaults.standard.integer(forKey: "items_up")
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            avm.getAlbumDetail(idAlbum: albumSelection.id_album)
            print(albumSelection)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(lenguaje == "es" ? "¡Listo!" : "Ok!")
                    .font(.largeTitle)
                    .bold()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("stickjoyLogo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(32)
            }
        }
    }
}

