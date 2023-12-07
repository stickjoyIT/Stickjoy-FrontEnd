//
//  NewAlbumHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

@available(iOS 16.0, *)
struct NewAlbumHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    @ObservedObject var editorVal = SetEditor()
    @State var nombreAlbum = "Nombre del álbum"
    @ObservedObject var avm = AlbumViewModel()
    
    @Binding var editorB:Bool
    @Binding var nameAlbum:String
    @Binding var imgPortda:String
    @Binding var descripAlbum:String
    @Binding var imges:[pickture]
    @Binding var id_album:String
    
    var userOwner:String
    
    @State var editNameAlbum = true
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    let limitNameAlbum = 20 //Your limit
    let limitDescripAlbum = 250
    @Binding var isActive:Bool
    @Binding var seeIt : Bool
    var body: some View {
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    //if !editorB {
                        //Botón de regresar
                        Button(action: {
                            // Add your action here
                            if !editorB {
                                presentationMode.wrappedValue.dismiss()
                                isActive = false
                                nameAlbum = ""
                            }
                        }) {
                            if editorB {
                                Image(systemName: "arrow.backward.circle.fill")
                                    .font(.title)
                                    .foregroundColor(scheme == .dark ? .black : .white)
                                    .cornerRadius(20)
                            } else {
                                Image(systemName: "arrow.backward.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                    .cornerRadius(20)
                            }
                            
                        }
                        //Añadí este frame para que el nombre de album quepa
                        .frame(width: 20, height: 20)
                        .padding()
                        .disabled(editorB)
                    
                        Spacer()
                        //Botón para entrar a editor de album
                    if !seeIt {
                        Button(action: {
                            // Add your action here
                            editorB = true
                        }) {
                            if editorB {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title)
                                    .foregroundColor(scheme == .dark ? .black : .white)
                                    .cornerRadius(20)
                            } else {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title)
                                    //.foregroundColor(.gray)
                                    .cornerRadius(20)
                            }
                            
                        }
                        //Añadí este frame para que el nombre de album quepa
                        .frame(width: 20, height: 20)
                        .padding()
                        .disabled(editorB)
                    }
                        
                    //}
                }
                
                HStack {
                    //Busca el título default del álbum
                    if editorB {
                        TextField("Nombre del Album",text: $nameAlbum)
                            .font(.largeTitle)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                            .bold()
                            .onReceive(Just(nameAlbum)) { _ in limitText(limitNameAlbum) }
                    } else {
                        Text(nameAlbum)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    
                }.padding(.leading,10)
                .padding(.trailing, 10)
                //Muestra administrador del álbum
                Text((userOwner.replacingOccurrences(of: " ", with: "")))
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                if editorB {
                    TextField("Descripcion del Album",text: $descripAlbum)
                        .autocorrectionDisabled(true)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .textInputAutocapitalization(.none)
                        .padding(.leading,10)
                        .padding(.trailing, 10)
                        .onReceive(Just(descripAlbum)) { _ in limitDescripAlbum(limitDescripAlbum) }
                } else {
                    Text(descripAlbum)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
            }
            .padding(0)
            .edgesIgnoringSafeArea(.top)
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
        .onAppear{
            let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            if descripAlbum == "" {
                
            }
            //descripAlbum = lenguaje == "es" ? "¡Bienvenid@ a mi nuevo álbum!" : "Welcome to my new album!"
        }
    }
    
    //Function to keep text length in limits
        func limitText(_ upper: Int) {
            if nameAlbum.count > upper {
                nameAlbum = String(nameAlbum.prefix(upper))
            }
        }
    
    func limitDescripAlbum(_ upper:Int){
        if descripAlbum.count > upper {
            descripAlbum = String(descripAlbum.prefix(upper))
        }
    }
}

