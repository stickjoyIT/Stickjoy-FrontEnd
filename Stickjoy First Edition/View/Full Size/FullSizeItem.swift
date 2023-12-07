//
//  FullSizeItem.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct FullSizeItem: View {
    var isVideo: Bool = false // Set this to true if it's a video
    @State private var isSoundOn = true // State to control sound
    @State private var isPlaying = false // State to control play/pause
    @Environment (\.dismiss) var dismiss
    @ObservedObject var avm = AlbumViewModel()
    @Binding var img:String
    @Binding var name_album:String
    @Binding var username:String
    @Binding var album_descrip:String
    @Binding var profileImg:String
    @State var imgPrevio = UIImage()
    @State var verPrev = false
    @State var nameUserPrev = ""
    @State var albumNamePrev = ""
    @Binding var indexScroll:Int
    @Binding var images:[pickture]
    @State var model = AVPlayer()
    @State var position = 0.0
    var body: some View {
        VStack {
            VStack(alignment:.leading){
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)
                            .padding(.bottom, 5)
                })
                    Spacer()
                }
            }
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(Array(images.enumerated()), id:\.offset ) { index,imgL in
                        LazyVStack(spacing: 0) {
                            if index % 9 == 0 {
                                if index > 1 {
                                    VStack {
                                        Text("Anuncio")
                                        BannerViewController(adUnitID: "ca-app-pub-7753738487380197/4863444949").padding(.bottom, 320)
                                            .padding(.horizontal, 40)
                                    }
                                }
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    //Conectar a Foto de Perfil de Usuario que subió
                                    WebImage(url: URL(string:imgL.user_url))
                                        .resizable()
                                        .placeholder(Image("stickjoyLogo"))
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(8)
                                        
                                    VStack(alignment: .leading, spacing: 4) {
                                        //Conectar a Nombre y Usuario de perfil que subió
                                        Text(imgL.user)
                                            .font(.headline)
                                        Text(imgL.user_name.replacingOccurrences(of: " ", with: ""))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 8)
                                //video img
                                videoOrImgView(url: imgL.url, tipo: imgL.tipo, image: imgL.image, ratio: imgL.ratio, alto: imgL.alto, ancho: imgL.ancho)
                                .onAppear {
                                    print("video aparece")
                                }
                                .onAppear {
                                    print("desaparece")
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(imgL.namePickture)
                                                .font(.title2)
                                            .bold()
                                            Text(imgL.description)
                                                .font(.body)
                                                .lineLimit(2)
                                                .padding(.trailing, 8)
                                        }
                                        
                                        Spacer()
                                        if imgL.tipo == 1 {
                                            //Botón de compartir en instagram stories
                                            Button(action: {
                                                //if let imageURL = URL(string: imgL.url) {
                                                    avm.loadImageFromURL(url: imgL.url) { (imageD) in
                                                        if let image = imageD {
                                                            verPrev = true
                                                            imgPrevio = image
                                                            nameUserPrev = username.replacingOccurrences(of: " ", with: "")
                                                            albumNamePrev = name_album
                                                        }
                                                    }
                                                //}
                                            }) {
                                                Image("instagramLogo")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                            }
                                            .sheet(isPresented: $verPrev, content: {
                                                PrevioInstagram(img: $imgPrevio, nameUser: $nameUserPrev, nameAlbum: $albumNamePrev)
                                            })
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                            }
                            
                        }
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 60)){
                            proxy.scrollTo(indexScroll, anchor: .top)
                        }
                    }
                }
            }///
            
        }
    }
}

struct videoOrImgView:View {
    @State var position = 0.0
    var url:URL
    var tipo:Int
    var image:UIImage
    @State var model = AVPlayer()
    var ratio : Double
    var alto : Double
    var ancho : Double
    var body: some View {
        VStack(alignment:.center) {
            if tipo == 1 {
                WebImage(url: url)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                
                VideoPlayer(player: model)
                    .aspectRatio(ratio, contentMode: .fill)
                    .padding(8)
                    .onAppear {
                        model.play()
                    }
                /*if let uri = URL(string: url) {
                    VideoPlayerView(videoURL: uri).frame(height: 300)
                }*/
            }
        }.onAppear{
            //if let uri = url {
            if tipo == 2 {
                model = AVPlayer(url: url)
            }
                
            //}
            
        }
        .onDisappear{
            print("desaparece dentro")
            if tipo == 2 {
                model.pause()
            }
        }
    }
}

struct FullSizeItem_Previews: PreviewProvider {
    static var previews: some View {
        FullSizeItem(isVideo: true, img: .constant("https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg"), name_album: .constant(""), username: .constant(""), album_descrip: .constant(""), profileImg: .constant(""), indexScroll: .constant(0), images: .constant([]))
    }
}

struct ImageShared: View {
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

extension View {
    func snapshot() -> UIImage {
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

// Custom video controls
struct VideoControls: View {
    
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

