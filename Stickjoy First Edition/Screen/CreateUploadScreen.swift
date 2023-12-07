//
//  CreateUploadScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre en Lista de Requerimientos: 6. Pop Up Menu - Crear/Subir
//  Paulo: Este pop up se convirtió en pantalla por temas de tiempos y navegación.
//  ¿Qué falta?: Falta conectar para una navegación correcta, y que al dar click en el botón de crear album, se cree un album que se vea reflejado en perfil.

import SwiftUI

@available(iOS 16.0, *)
struct CreateUploadScreen: View {
    @ObservedObject var editorB = SetEditor()
    @StateObject var avm = AlbumViewModel()
    @StateObject var uvm = UsuariosViewModel()
    @ObservedObject var dtb = DataBase()
    @State var listElementsSelected = [ElementItem]()
    @StateObject var stm = StorageManager()
    @State var isActive = false
    @State var isUploadPick = false
    @State var pickturesList = [String]()
    @State var id_album = ""
    @State var privacy = 0
    @Binding var lenguaje:String
    @State var userOwner = ""
    @State var isActiveRoot : Bool = false
    @Binding var proceso:Bool
    @Binding var porcentaje:Float
    @State var items_up = 0
    @State var album_update = ""
    @State var procesos = false
    @State var isUpload = false
    @State var isUploadN = false
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    //Botón de subir foto o video
                    Spacer()
                        VStack(alignment:.center) {
                            Spacer()
                            NavigationLink(destination: ChooseAlbumScreen(rootIsActive: $isActiveRoot, proceso: $proceso, porcentaje: $porcentaje, isActive: $isActive), isActive: $isActiveRoot, label: {
                                
                                HStack {
                                    Image(systemName: "plus.fill")
                                    Text(lenguaje == "es" ? "Sube contenido" : "Upload content")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(width: 250)
                                
                            })
                            .foregroundColor(.black)
                            .background(procesos ? .gray : Color.yellow)
                            .cornerRadius(8)
                            .frame(width: 250)
                            .disabled(procesos)
                            //Botón de crear álbum
                            Button(action: {
                                //Debe crear un álbum y enviarte a esa pantalla.
                                editorB.editor = true
                                id_album = ""
                                editorB.nameAlbum = lenguaje == "es" ? "Nombre del álbum" : "Album name"
                                editorB.descripAlbum = lenguaje == "es" ? "Bienvenid@ a mi nuevo álbum" : "Welcome to mi new album"
                                editorB.imgPortada = ""
                                avm.urlImagesAlbum = []
                                isActive = true
                            }) {
                                HStack {
                                    Image(systemName: "photo.stack.fill")
                                    Text(lenguaje == "es" ? "Crear un nuevo álbum" : "Create new album")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(width: 250)
                            }
                            .frame(width: 250)
                            .foregroundColor(.white)
                            .background(procesos ? .gray : Color.blue)
                            .cornerRadius(8)
                            .disabled(procesos)
                            Spacer()
                        }
                        //.snackbar(isShowing: $isUpload, title: Text(""), text: Text(lenguaje == "es" ? "Espere a que finalice la carga para agregar" : "Wait for the upload to finish"), style: .custom(Color(hex: "FFD966")), dismissAfter: 5)
                        
                    Spacer()
                    HStack {}
                        .padding()
                        .frame(maxWidth:.infinity)
                        .overlay(
                            SnackBar(message: lenguaje == "es" ? "Espere a que finalice la carga para agregar" : "Wait for the upload to finish", isShowing: $isUpload)
                                .animation(.easeInOut, value: isUpload)
                        )
                        
                }
                .edgesIgnoringSafeArea(.top)
                .padding()
                .fullScreenCover(isPresented: $isActive, content: {
                    NewAlbumScreen(avm: avm, uvm: uvm, isEdit: .constant(false), editor: $editorB.editor, nameAlbum: $editorB.nameAlbum, descripAlbum: $editorB.descripAlbum, id_albumSelected: $id_album, imgPortadaBind: $editorB.imgPortada, pickturesList: $avm.picktureList, lenguaje: $lenguaje, privacy: $privacy, proceso: $proceso, userOwner: userOwner, items_up: $items_up, album_up: $album_update, rootIsActive: $isActiveRoot, isUploadN: $isUploadN, porcentaje: $porcentaje, isActive: $isActive, seeIt: .constant(false))
                })
                .fullScreenCover(isPresented: $isUploadPick, onDismiss: {
                    
                },content: {
                    //ChooseAlbumScreen(rootIsActive: .constant(false), lenguaje: $lenguaje, avm: avm, stm: stm)
                })
                .onChange(of: isActive, perform: { val in
                    if val {
                        //Debe crear un álbum y enviarte a esa pantalla.
                        editorB.editor = true
                        id_album = ""
                        editorB.nameAlbum = lenguaje == "es" ? "Nombre del álbum" : "Album name"
                        editorB.descripAlbum = lenguaje == "es" ? "Bienvenid@ a mi nuevo álbum" : "Welcome to mi new album"
                        editorB.imgPortada = ""
                        avm.urlImagesAlbum = []
                        isActive = true
                    }
                })
                
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                userOwner = UserDefaults.standard.string(forKey: "username") ?? ""
                UserDefaults.standard.set(false, forKey: "uploading")
                print("crea")
                items_up = UserDefaults.standard.integer(forKey: "items_up")
            }
            .navigationBarTitleDisplayMode(.automatic)
           //.navigationTitle()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(lenguaje == "es" ? "Crea" : "Create")
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
            .onAppear {
                procesos = proceso
                if proceso {
                   isUpload = true
                    
                } else {
                    porcentaje = 0
                }
            }
        }
    }
}


@available(iOS 16.0, *)
struct CreateUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateUploadScreen(lenguaje: .constant("es"), proceso: .constant(false), porcentaje: .constant(80))
    }
}

struct SnackBar: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            if isShowing {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "FFD966"))
                    .cornerRadius(8)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                    }
                    .foregroundColor(.black)
            }
        }
        .transition(.move(edge: .top))
    }
}
