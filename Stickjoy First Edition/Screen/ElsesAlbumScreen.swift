//
//  ElsesAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre de Lista de Requerimientos: 16. Pantalla de Album Ajeno
//  Paulo: Es casi igual que AlbumScreen solo con los botones de encabezado que se ven en FIGMA. Ponerlos a la altura igual que ElsesProfileScreen solo que el botón de anclar se reemplaza por el de Image(systemName: "ellipsis.circle.fill") que abre la pantalla de AlbumInfoPanelScreen.swift

import SwiftUI
import SDWebImageSwiftUI

struct ElsesAlbumScreen: View {
    @State var gridN = 3
    @Binding var id_album:String
    @Binding var nameAlbum:String
    @Binding var descripAlbum:String
    @Binding var username:String
    @Binding var imgPortada:String
    @State var pickturesList = [String]()
    @Environment (\.colorScheme) var scheme
    @Environment (\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                    ElsesAlbumHeader(nameAlbum: $nameAlbum, descripAlbum: $descripAlbum, username: $username, imgPortada: $imgPortada).frame(height:100).padding(.top, 40)
            }
        }
    }
    
    struct ElsesAlbumScreen_Previews: PreviewProvider {
        static var previews: some View {
            ElsesAlbumScreen(id_album: .constant(""), nameAlbum: .constant("Nuevo album"), descripAlbum: .constant("Descripcion album"), username: .constant("username"), imgPortada: .constant("https://firebasestorage.googleapis.com:443/v0/b/stickjoy-swiftui.appspot.com/o/AJVuYmOk0AUCNNuMY9le%2FIMG_0005.jpeg?alt=media&token=a48f40ce-01f1-44da-963b-b32882dce548"))
        }
    }
    
    struct ElsesAlbumHeader: View {
        @Environment (\.colorScheme) var scheme
        @Environment (\.dismiss) var dismiss
        
        @Binding var nameAlbum:String
        @Binding var descripAlbum:String
        @Binding var username:String
        @Binding var imgPortada:String
        
        var body: some View{
            ZStack(alignment: .top) {
                (scheme == .dark ? Color.black : Color.white)
                VStack(alignment: .leading, spacing: 8) {
                    if imgPortada.isEmpty {
                        Image("ProfilePic")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill).background(Color(hex: "9dc3e6"))
                    } else {
                        AnimatedImage(url: URL(string: imgPortada))
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill).background(Color(hex: "9dc3e6"))
                    }
                    
                    //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                    //Título de álbum
                    HStack {
                        //Busca el título default del álbum
                        Text(nameAlbum)
                            .font(.system(size: 24))
                            .fontWeight(.light)
                        
                    }.padding(.leading,10)
                        .padding(.trailing, 10)
                    
                    //Muestra administrador del álbum
                    Text("@"+username)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .fontWeight(.light)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    Text(descripAlbum)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .fontWeight(.light)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
                .padding(0)
                .edgesIgnoringSafeArea(.top)
                //Layout de botones de regresar y editar
                HStack {
                    //Botón de regresar
                    Button(action: {
                        // Add your action here
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    colors: [.customBlue, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                    
                                )
                            )
                            .cornerRadius(20)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                    Spacer()
                    //Botón para entrar a editor de album
                    Button(action: {
                        // Add your action here
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title).foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    colors: [.customBlue, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 150)
                
            }.edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
                .onAppear{
                    
                }
        }
    }
}
