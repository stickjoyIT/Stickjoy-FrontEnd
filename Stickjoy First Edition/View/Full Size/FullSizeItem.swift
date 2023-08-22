//
//  FullSizeItem.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import SwiftUI

struct FullSizeItem: View {
    var isVideo: Bool = false // Set this to true if it's a video
    
    @State private var isSoundOn = true // State to control sound
    
    @State private var isPlaying = false // State to control play/pause

    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        //Conectar a Foto de Perfil de Usuario que subió
                        Image("profilePicture")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                        VStack(alignment: .leading, spacing: 4) {
                            //Conectar a Nombre y Usuario de perfil que subió
                            Text("Profile Name")
                                .font(.headline)
                            Text("@username")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    //Conectar a foto o vídeo que se subió
                    Image("uploadedPicture")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    
                    if isVideo {
                        // Custom video controls
                        VideoControls(isSoundOn: $isSoundOn)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("New!")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: .infinity, height: 30)
                                .padding(.horizontal, 16)
                                .background(Color.blue)
                                .cornerRadius(32)
                            Spacer()
                            
                            //Botón de compartir en instagram stories
                            Button(action: {
                                //Añadir acción
                            }) {
                                Image("instagramLogo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        Text("Picture name")
                            .font(.title2)
                            .bold()
                        Text("Description of the picture or video goes here")
                            .font(.body)
                            .lineLimit(2)
                            .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FullSizeItem_Previews: PreviewProvider {
    static var previews: some View {
        FullSizeItem(isVideo: true)
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
