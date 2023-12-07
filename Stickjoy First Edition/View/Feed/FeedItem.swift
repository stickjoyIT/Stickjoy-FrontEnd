//
//  FeedItem.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Archivo de Items de feed. 

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import AVKit

struct FeedItem: View {
    var isVideo: Bool = false // Set this to true if it's a video
    
    @State private var isSoundOn = true // State to control sound
    
    @State private var isPlaying = false // State to control play/pause
    @ObservedObject var avm = AlbumViewModel()
    @ObservedObject var uvm = UsuariosViewModel()
    @Binding var albumView:Bool
    @Binding var itemFeed:itemFeed
    @Binding var lenguaje:String
    @Binding var id_album:String
    @Binding var name_album:String
    @Binding var descrip_album:String
    @Binding var imgPortada:String
    @Binding var username:String
    @Binding var id_usuario:String
    @State var isProfile = false
    @State var albums = [ElsesAlbumInfo]()
    @State var imageP = Image("instagramLogo")
    
    @State var isPin = false
    @State var isFriend = false
    @State var isPend = false
    @State var imgPrevio = UIImage()
    @State var verPrev = false
    @State var nameUserPrev = ""
    @State var albumNamePrev = ""
    @State var tipo = 1
    @State var model = AVPlayer()
    @State var imgPortadaFriend = ""
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button(action: {
                            //Añadir que te lleva a su perfil
                            uvm.getUserPinetOrFriend(id_elseuser: itemFeed.user_id, result: { rep in
                                id_usuario = itemFeed.user_id
                                isProfile = true
                                isPin = rep.pinned
                                isFriend = rep.frined
                                isPend = rep.pend
                                username = itemFeed.username
                                descrip_album = itemFeed.album_description
                                imgPortadaFriend = itemFeed.user_url
                            })
                        }) {
                            //Conectar a Foto de Perfil de Usuario que subió
                            WebImage(url: URL(string: itemFeed.user_url))
                                .resizable()
                                .placeholder(Image("stickjoyLogo"))
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            //Conectar a Nombre y Usuario de perfil que subió
                            Text(itemFeed.name)
                                .font(.headline)
                            Text(itemFeed.username.replacingOccurrences(of: " ", with: ""))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    //Conectar a foto o vídeo que se subió
                    if itemFeed.tipo == 1{
                        WebImage(url: URL(string: itemFeed.picture_url))
                            .resizable()
                            .placeholder(Image("stickjoyLogo"))
                            .indicator(.progress)
                            .aspectRatio(contentMode: .fill)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else {
                        VideoFeed(ratio: itemFeed.ratio, url: itemFeed.picture_url)
                            .onAppear {
                                print("video aparece")
                            }
                            .onAppear {
                                print("desaparece")
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if itemFeed.isNew != ""{
                                Text(itemFeed.isNew)
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: 60)
                                    .frame(height: 30)
                                    .padding(.horizontal, 4)
                                    .background(Color.blue)
                                    .cornerRadius(32)
                            }
                            Text("Subido "+itemFeed.picture_created_date)
                            Spacer()
                            
                            //Botón de ir a álbum
                            Button(action: {
                                //Añadir acción de ir al álbum
                                albumView = true
                                id_album = itemFeed.album_id
                                name_album = itemFeed.album_name
                                descrip_album = itemFeed.album_description
                                imgPortada = itemFeed.album_url
                                username = itemFeed.username
                                id_usuario = itemFeed.user_id
                            }) {
                                Text(lenguaje == "es" ? "Ir al álbum" : "Go to Album")
                                    .foregroundColor(.black)
                                    .bold()
                                    .frame(height: 30)
                                    .padding(.horizontal, 16)
                                    .background(Color.yellow)
                                    .cornerRadius(32)
                            }
                            //Botón de compartir en instagram stories
                            Button(action: {
                                //Añadir acción
                                if !itemFeed.picture_url.isEmpty {
                                    // Uso:
                                    print("enviar a ins:",itemFeed.picture_url)
                                    if let imageURL = URL(string: itemFeed.picture_url) {
                                        avm.loadImageFromURL(url: imageURL) { (imageD) in
                                            if let image = imageD {
                                                verPrev = true
                                                imgPrevio = image
                                                nameUserPrev = itemFeed.username.replacingOccurrences(of: " ", with: "")
                                                albumNamePrev = itemFeed.album_name
                                                
                                            } else {
                                                // Maneja el caso en el que no se pudo cargar la imagen
                                            }
                                        }
                                    }
                                }
                                
                            }) {
                                Image("instagramLogo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }.sheet(isPresented: $verPrev, content: {
                                PrevioInstagram(img: $imgPrevio, nameUser: $nameUserPrev, nameAlbum: $albumNamePrev)
                            })
                        }
                        if !itemFeed.picture_name.isEmpty {
                            Text(itemFeed.picture_name)
                                .font(.title2)
                                .bold()
                        }
                        if !itemFeed.picture_description.isEmpty {
                            Text(itemFeed.picture_description)
                                .font(.body)
                                .lineLimit(2)
                                .padding(.trailing, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                uvm.getFeedUser(feeds: { fd in
                    
                })
            }
            .fullScreenCover(isPresented: $isProfile, content: {
                ElsesProfileScreen(uvm: uvm, id_usuario: $id_usuario, isPinet: $isPin, isFriend: $isFriend, pend: $isPend, name: $username, username: $username, descrip: $descrip_album, FriendAlbums: $albums, imgPortada: $imgPortadaFriend, proceso: .constant(false), album_up: .constant(""), porcentaje: .constant(0.0), items_up: .constant(0))
            })
        }
    }
    
    func getTypeFile(url:URL) {
        switch try! url.resourceValues(forKeys: [.contentTypeKey]).contentType! {
        case let contentType where contentType.conforms(to: .image):
            tipo = 1
        case let contentType where contentType.conforms(to: .audiovisualContent):
            tipo = 2
            model = AVPlayer(url: URL(string:itemFeed.picture_url)!)
        default:
            tipo = 1
        }
    }
    
}

struct FeedItem_Previews: PreviewProvider {
    static var previews: some View {
        FeedItem(isVideo: false, albumView: .constant(false), itemFeed: .constant(itemFeed(album_id: "", album_name: "Prueba", album_description: "Este es mi album", album_url: "", name: "Ignacio", picture_created_date: "Hace 25 min", picture_url: "", picture_description: "", picture_name: "", username: "ignacio", user_id: "", user_url: "", isNew: "", image: UIImage(named: "")!, tipo: 1, ratio: 0.0)), lenguaje: .constant("es"), id_album: .constant(""), name_album: .constant("Visita al parue"), descrip_album: .constant("Visita"), imgPortada: .constant(""), username: .constant(""), id_usuario: .constant(""))
    }
}

struct VideoFeed:View {
    @State var model = AVPlayer()
    var ratio:Double
    var url:String
    var body: some View {
        VStack {
            VideoPlayer(player: model)
                .aspectRatio(ratio, contentMode: .fill)
                .padding(8)
                .onAppear {
                    model.play()
                }
        }.onAppear {
            print("video aparece")
            if let uri = URL(string: url) {
                model = AVPlayer(url: uri)
            }
        }
        .onDisappear{
            print("video desaparece")
            model.pause()
        }
    }
}

struct PrevioInstagram: View {
    @Binding var img:UIImage
    @Binding var nameUser:String
    @Binding var nameAlbum:String
    @ObservedObject var avm = AlbumViewModel()
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Añadir ir hacia atrás. Te lleva de vuelta al AdminPanelScreen.
                    dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }.padding(.horizontal, 10)
                .padding(.top, 10)
            Spacer()
            disenioInsta(img: $img, nameUser: $nameUser, nameAlbum: $nameAlbum)
            Spacer()
            Button(action: {
                let imagen = disenioInsta(img: $img, nameUser: $nameUser, nameAlbum: $nameAlbum).snapshotIns()
                avm.sendUImageToInstagram(image: imagen)
            }, label: {
                
                Text("Compartir")
            })
        }
    }
        
}

struct disenioInsta : View {
    @Binding var img:UIImage
    @Binding var nameUser:String
    @Binding var nameAlbum:String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                //El logo ya lo tienes
                Image("stickjoyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .cornerRadius(24)
                
                VStack(alignment: .leading, spacing: 4) {
                    //El texto es con ACME regular
                    Text("Stickjoy")
                        .foregroundColor(.black)
                        .bold()
                    
                    //Personal and collaborative albums
                    Text("Collaborative and personal albums")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundColor(.black)
                }
            }
            // Esta es la foto o video compartida
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fit)
            //El frame es 300, está en .fit para que la altura dependa del width.
                .frame(width: 300)
                .cornerRadius(8)
            
            //Aquí va el nombre del username que creó esta foto o video.
            Text(nameUser)
                .font(.callout)
                .foregroundColor(.black)
            
            //Aquí va el nombre del álbum al que pertenece la foto o vídeo.
            Text(nameAlbum)
                .font(.caption2)
                .foregroundColor(.black)
                .fontWeight(.light)
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 6)
    
    }
    
}

// Custom video controls
struct FeedVideoControls: View {
    
    //Binding para controlar el estado de sonido.
    @Binding var isSoundOn: Bool
    
    //Controlar play o pausa, se pone play por default.
    @State private var isPlaying = true

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                //Para desactivar o activar sonido
                Image(systemName: isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.system(size: 20))
                    .frame(width: 20, height: 30)
                    .onTapGesture {
                        isSoundOn.toggle()
                    }
                
                Button(action: {
                    isPlaying.toggle() // Toggle play/pause
                }) {
                    Image(systemName: isPlaying ? "play.fill" : "pause.fill")
                        .frame(width: 20, height: 30)
                }
                ProgressView(value: 0.5)
                    .font(.callout)
                Text("02:30 / 05:00")
                    .font(.callout)
            }
        }
    }
}

extension View {
    func snapshotIns() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
