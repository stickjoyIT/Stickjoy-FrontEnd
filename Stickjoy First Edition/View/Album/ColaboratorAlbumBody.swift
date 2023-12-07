//
//  ColaboratorAlbumBody.swift
//  Stickjoy First Edition
//
//  Created by admin on 10/11/23.
//

import SwiftUI

import SDWebImageSwiftUI

struct ColaboratorAlbumBody: View {
    @ObservedObject var avm:AlbumViewModel
    @Binding var id_albumSelected:String
    @Binding var pickturesList:[pickture]
    @State var imgUrl = ""
    @State var indexScroll = 0
    @State var indexImgSelected = 0
    @State var alertConfirm = false
    @State var showAlert = false
    @State var lenguaje = ""
    @State var mensaje = ""
    @State var myId = ""
    
    var body: some View {
        VStack {
            let colums3 = Array(repeating: GridItem(spacing:10), count: 3)
            LazyVGrid(columns: colums3, content: {
                ForEach(Array(avm.picktureList.enumerated()), id:\.offset) { indexI, list in
                    GeometryReader {
                        let sizeIm = $0.size
                        ZStack(alignment:.topLeading) {
                            if list.tipo == 1 {
                                AnimatedImage(url: list.url)
                                    .indicator(SDWebImageActivityIndicator.medium)
                                    .transition(.fade)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: sizeIm.width, height: sizeIm.height)
                                    .cornerRadius(10)
                            } else {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(uiImage: list.image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:sizeIm.width, height: sizeIm.height)
                                        .cornerRadius(10)
                                    
                                    Text(list.duration)
                                        .padding(4)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Button(action:{
                                alertConfirm = true
                                indexImgSelected = indexI
                            }, label: {
                                Image(systemName: "trash.circle.fill").frame(width:30, height: 30).font(.title)
                            })
                            .opacity(myId == list.user_id ? 1.0 : 0.0)
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .confirmationDialog(lenguaje == "es" ? "Eliminar archivo" : "Delete file", isPresented: $alertConfirm){
                                Button("Aceptar", role: .destructive) {
                                    avm.deleteMedia(id_user: pickturesList[indexImgSelected].user_id, id_album: pickturesList[indexImgSelected].album_id, id_media: pickturesList[indexImgSelected].id_img) { resp in
                                        mensaje = resp.message
                                        if resp.status == 200 {
                                            pickturesList.remove(at: indexImgSelected)
                                            avm.getAlbumDetailMatrix(idAlbum: id_albumSelected)
                                        }
                                        showAlert = true
                                    }
                                }
                                Button("Cancelar", role: .cancel) {
                                }
                            } message : {
                                Text("¿Esta seguro de Eliminar el archivo?").font(.largeTitle)
                            }
                            .alert(isPresented: $showAlert, content: {
                                Alert(title: Text("Mensaje"), message: Text(mensaje))
                            })
                        }
                    }.frame(height: 100)
                }
            })
        }
        .padding(10)
        .onAppear {
            myId = UserDefaults.standard.string(forKey: "id") ?? ""
        }
    }
}
