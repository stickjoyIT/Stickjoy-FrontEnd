//
//  DetailSelectionScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 27/11/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct DetailSelectionScreen: View {
    @StateObject var stm:StorageManager
    @Binding var shouldPopToRootView : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var lenguaje:String
    @State var selectItemId = UUID()
    @State var showAlert = false
    //@State var model = AVPlayer()
    @Binding var isAlbumRoot : Bool
    @Binding var proceso : Bool
    var albumSelected:AlbumSelectView
    @Binding var porcentaje : Float
    @Binding var album_up:String
    @Binding var items_up:Int
    @Binding var isUpload:Bool
    @Binding var isDetailv:Bool
    @State var index = -1
    @FocusState var focusedField:UUID?
    @Environment (\.colorScheme) var scheme
    var body: some View {
        VStack {
            ScrollView {
                ForEach($stm.listaImagenes, id: \.id){ item in
                    LazyVStack(alignment: .leading) {
                        VideoImagePrev(item: item, index: index, lenguaje: lenguaje, listaImages: $stm.listaImagenes, stm: stm)
                        DinamicTextFields(lenguaje: $lenguaje, name: item.name, descrip: item.description, id: item.id)
                    }
                    .padding(8)
                }
            }
            .padding(.top, 10)
            if stm.listaImagenes.count > 0 {
                if isAlbumRoot {
                    Button(action: {
                        print(stm.listaImagenes.count)
                        UserDefaults.standard.set(true, forKey: "uploading")
                        UserDefaults.standard.set(stm.listaImagenes.count, forKey: "items_up")
                        proceso = true
                        items_up = stm.listaImagenes.count
                        album_up = albumSelected.id_album
                        DispatchQueue.global().async {
                            stm.updateTest(id_album: albumSelected.id_album, nameAlbum: albumSelected.name, upload: { up in
                                print(up)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    if up {
                                        stm.listaImagenes = []
                                        UserDefaults.standard.set(false, forKey: "uploading")
                                        proceso = false
                                        porcentaje = 0
                                        //avm.getAlbumDetail(idAlbum: albumSelected.id_album)
                                    }
                                }
                            }, porcent: { p in
                                porcentaje = p
                            })
                        }
                        shouldPopToRootView = false
                    }, label: {
                        Text(lenguaje == "es" ? "Subir" : "Upload")
                            .padding()
                            .foregroundColor(scheme == .dark ? .white : .black)
                            .frame(maxWidth: 250)
                            .background(Color(hex: "#9dc3e6"))
                            .cornerRadius(18)
                            .padding(10)
                    })
                    .padding(.bottom, 20)
                } else {
                    NavigationLink(destination: UploadingScreen(stm: stm, shouldPopToRootView: $shouldPopToRootView, proceso: $proceso, albumSelected: albumSelected, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload: $isUpload, isDetailV: $isDetailv), label: {
                        HStack {
                            Text(lenguaje == "es" ? "Subir" : "Upload")
                                .padding()
                        }
                        .foregroundColor(scheme == .dark ? .white : .black)
                    })
                    .frame(maxWidth: 250)
                    .background(Color(hex: "#9dc3e6"))
                    .cornerRadius(18)
                    .padding(10)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(lenguaje == "es" ? "Tu selección" : "Your selection")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button(action: {
                   presentationMode.wrappedValue.dismiss()
               }, label: {
                   HStack {
                       Image(systemName: "chevron.left")
                       Text(lenguaje == "es" ? "Ver todo" : "See all")
                   }
               })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Regresar a la vista raíz
                    shouldPopToRootView = false
                    isDetailv = false
                    isUpload = false
                }) {
                    Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                }
            }
        }
        .onAppear {
            UIApplication.shared.endEditing()
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct VideoImagePrev : View{
    @Binding var item:ElementItem
    var index:Int
    var lenguaje:String
    @Binding var listaImages:[ElementItem]
    @State var silent = true
    @State var pause = true
    @StateObject var stm:StorageManager
    @State var model = AVPlayer()
    @State var selectItemId = UUID()
    @State var showAlert = false
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                ZStack(alignment: .topLeading) {
                    if item.tipo == 2 {
                        VideoPlayer(player: model)
                            .aspectRatio(item.ratio, contentMode: .fill)
                            .padding(8)
                            .onAppear {
                                if let uri = URL(string: item.url) {
                                    model = AVPlayer(url: uri)
                                    model.play()
                                    pause = false
                                    model.volume = 0.0
                                }
                            }
                            .onDisappear {
                                model.pause()
                                pause = true
                            }
                    } else {
                        WebImage(url: URL(string: item.url))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                    HStack {
                        Text("\(index + 1) \(lenguaje == "es" ? "de" : "of") \(stm.listaImagenes.count)")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(hex: "d6d6d6"))
                            .cornerRadius(18)
                            .padding(.top, 8)
                            .padding(.leading,8)
                        Spacer()
                    }
                    .padding(item.tipo == 2 ? 10 : 0)
                    
                }
                Button(lenguaje == "es" ? "Quitar" : "Delete") {
                    selectItemId = item.id
                    print(index)
                    showAlert = true
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(hex: "d6d6d6"))
                .cornerRadius(18)
                .padding(.top, 8)
                .padding(.leading,8)
                .foregroundColor(.red)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(lenguaje == "es" ? "Mensaje" : "Messagge"),
                          message: Text(lenguaje == "es" ? "¿Quieres eliminar este elemento?" : "Are you sure you want to delete it?"),
                          primaryButton: .default(Text(lenguaje == "es" ? "Aceptar" : "Accept"), action: {
                        // Acción cuando se presiona Aceptar
                        print(index)
                        //if let indexEl = listaImages.firstIndex(where: {$0.id == selectItemId}) {
                        listaImages = listaImages.filter { $0.id != selectItemId }
                        //}
                    }),
                          secondaryButton: .cancel(Text(lenguaje == "es" ? "Cancelar" : "Cancel")))
                }
                .padding(.bottom, 8)
                .padding(item.tipo == 2 ? 10 : 0)
            }
            
            
            if item.tipo == 2 {
                HStack {
                    Button(action: {
                        pause.toggle()
                        if pause {
                            model.pause()
                        } else {
                            model.play()
                        }
                        
                    }, label: {
                        Image(systemName: pause ? "play.fill" : "pause.fill")
                            .font(.title)
                    })
                    Spacer()
                    Button(action: {
                        silent.toggle()
                        model.volume = silent ? 0.0 : 100.0
                        model.isMuted = silent
                        
                    }, label: {
                        if silent {
                            Image(systemName: "speaker.slash.fill")
                                .font(.title)
                        } else {
                            Image(systemName: "speaker.fill")
                                .font(.title)
                        }
                        
                    })
                    
                }
                .padding(4)
            }
            
        }
        .onAppear {
            print("uuid: ", item.id)
        }
        
    }
}
struct DinamicTextFields : View {
    @Binding var lenguaje:String
    @Binding var name:String
    @Binding var descrip:String
    
    @FocusState var focusedField:UUID?
    @Binding var id:UUID
    var body: some View {
        VStack(spacing: 10) {
            TextField(lenguaje == "es" ? "Agrega un nombre" : "Add name", text: $name)
            .font(.title)
            .focused($focusedField, equals: id)
            .onTapGesture {
                focusedField = id
            }
            TextField(lenguaje == "es" ? "Agrega una descripcion" : "Add description", text: $descrip)
        }
        .padding(.top, 8)
    }
}
