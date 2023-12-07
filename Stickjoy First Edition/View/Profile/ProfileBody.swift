//
//  ProfileBody.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.

import SwiftUI
import SDWebImageSwiftUI
import Lottie

@available(iOS 16.0, *)
struct ProfileBody: View {
    
    var albumsinfo: AlbumInfo
    
    @ObservedObject var avm:AlbumViewModel
    @ObservedObject var uvm:UsuariosViewModel
    
    @Binding var albumName:String
    @Binding var albumDecripcion:String
    @Binding var imgPortada:String
    
    @Binding var editor:Bool
    @Binding var editorP:Bool
    @Binding var albums:[AlbumInfo]
    @Binding var privacy:Int
    @Binding var lenguaje:String
    @State var isActive = false
    @State var isColaborator = false
    @Binding var pickturesList: [pickture]
    @State var userOwner = ""
    @State var alertDeleteAlbum = false
    @State var albumSelected = ""
    @State var processing = false
    @State var album_update = ""
    @Binding var proceso:Bool
    @State var item_upload = 0
    @State var isActiveRoot : Bool = false
    @Binding var porcentaje : Float
    @State var isUploadN = false
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 16, content: {
                
                Text(albumsinfo.albumTitle)
                    .font(.title)
                    .bold()
                
                //Botón de álbum para abrir la pantalla de álbum
                ZStack(alignment: .topTrailing) {
                    Button(action: {
                        if !editorP {
                            if albumsinfo.isCollap {
                                //avm.getAlbumDetail(idAlbum: albumsinfo.id_album)
                                isColaborator = true
                            } else {
                                avm.getAlbumDetail(idAlbum: albumsinfo.id_album)
                                privacy = albumsinfo.albumPrivacy
                                albumDecripcion = albumsinfo.description
                                albumName = albumsinfo.albumTitle
                                imgPortada = albumsinfo.albumImage
                                isActive = true
                            }
                        }
                    }) {
                        ZStack(alignment: .bottom) {
                            if !albumsinfo.albumImage.isEmpty {
                                AnimatedImage(url: URL(string: albumsinfo.albumImage))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 250)
                                    .cornerRadius(24)
                            } else {
                                Image("stickjoyLogoBlue")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 250)
                                    .cornerRadius(24)
                            }
                            
                            if proceso && albumsinfo.id_album == album_update {
                                ElementsCountUploadScreen(numeroElementos: $item_upload, porcent: $porcentaje, lenguaje: $lenguaje)
                                    .frame(maxWidth: 320)
                                    .background(.white)
                                    .cornerRadius(16)
                                    .padding(8)
                            }
                        }
                    }
                    if !albumsinfo.isCollap {
                        Button(action: {
                            alertDeleteAlbum = true
                            albumSelected = albumsinfo.id_album
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                        })
                        .padding()
                        .opacity(editorP ? 1.0 : 0.0)
                        .confirmationDialog(lenguaje == "es" ? "Eliminar álbum" : "Delete album", isPresented: $alertDeleteAlbum){
                            Button("Aceptar", role: .destructive) {
                                deleteAlbum(id_album: albumSelected)
                            }
                            Button("Cancelar", role: .cancel) {
                            }
                        } message : {
                            Text(lenguaje == "es" ? "¿Estás seguro de que quieres borrar (\(albumsinfo.albumTitle))?" : "Are you sure you want to delete (\(albumsinfo.albumTitle))?").font(.largeTitle)
                        }
                    }
                }
                
                Text(albumsinfo.albumAdministrator)
                    .font(.headline)
                //Creación y Actualización de Álbum
                HStack {
                    Text(albumsinfo.albumCreation)
                        .font(.callout)
                    
                    Text(albumsinfo.albumUpdate)
                        .font(.callout)
                }
                //Tipo, Participantes y Privacidad del álbum
                HStack {
                    Text(albumsinfo.albumType)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    
                    Text(albumsinfo.albumParticipants)
                        .font(.footnote)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                    switch albumsinfo.albumPrivacy {
                    case 0:
                        Text(lenguaje == "es" ? "Privado" : "Private")
                            .font(.footnote)
                    case 1:
                        Text(lenguaje == "es" ? "Amigos" : "Friends")
                            .font(.footnote)
                    case 2:
                        Text(lenguaje == "es" ? "Público" : "Public")
                            .font(.footnote)
                    default:
                        Text("")
                            .font(.footnote)
                    }
                    
                }
            })
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
        .fullScreenCover(isPresented: $isActive, onDismiss: {
            avm.getAlbumList(){ result in
                albums = result
            } responseData: { resp in
                
            }
        }, content: {
            NewAlbumScreen(avm: avm, uvm: uvm, imgPortada:albumsinfo.albumImage ,id_album: albumsinfo.id_album, isEdit: .constant(true), editor: $editor, nameAlbum: $albumName,descripAlbum: $albumDecripcion, id_albumSelected: .constant(albumsinfo.id_album), imgPortadaBind: $imgPortada, pickturesList: $avm.picktureList, lenguaje: $lenguaje, privacy: $privacy, proceso: $proceso, userOwner: albumsinfo.userOwner, items_up: $item_upload, album_up: $album_update, rootIsActive: $isActiveRoot, isUploadN: $isUploadN, porcentaje: $porcentaje, isActive: $isActive, seeIt: .constant(false))
        })
        .fullScreenCover(isPresented: $isColaborator, content: {
            ElsesAlbumScreen(avm: avm, id_album:.constant(albumsinfo.id_album) , nameAlbum: .constant(albumsinfo.albumTitle), descripAlbum: .constant(albumsinfo.description), username: .constant(albumsinfo.userOwner), imgPortada: .constant(albumsinfo.albumImage), id_user: .constant(albumsinfo.owner_id), pickturesList: $avm.picktureList, iColaborator: .constant(albumsinfo.isCollap), proceso: $proceso, album_up: $album_update, porcentaje: $porcentaje, items_up: $item_upload, isCollaborator: $isColaborator)
        })
        .onAppear {
            processing = UserDefaults.standard.bool(forKey: "uploading")
            album_update = UserDefaults.standard.string(forKey: "album_update") ?? ""
            item_upload = UserDefaults.standard.integer(forKey: "items_up")
            print("id subido: \(album_update)")
        }
    }
    
    func deleteAlbum(id_album:String){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        avm.deleteAlbum(id: id, album: id_album, responseData: { resp in
            avm.getAlbumList(){ result in
                albums = result
            } responseData: { resp in
                
            }
        })
    }
}
