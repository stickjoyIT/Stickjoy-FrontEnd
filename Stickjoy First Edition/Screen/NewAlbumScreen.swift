//
//  NewAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI
import AVKit
import MediaPicker
import Firebase
import FirebaseStorage

struct NewAlbumScreen: View {
    @State var gridN = 3
    @State private var colors:[Color] = [.blue, .black, .gray, .green, .yellow]
    @State private var draggItem: Color?
    @Environment (\.colorScheme) var scheme
    var storageManager = StorageManager()
    @ObservedObject var editorVal = SetEditor()
    @ObservedObject var avm = AlbumViewModel()
    @State var urls = [URL]()
    @State var urlsP = [URL]()
    @State var isShowingMediaPicker = false
    
    @State var showSnack = false
    
    @State var imagenUrl = ""
    @State var imgPortada = ""
    @State var id_album = ""
    @State var imgPPrev = ""
    @State var nameAlbumPrev = ""
    @State var descripPrev = ""
    
    @Binding var isEdit:Bool
    @Binding var editor:Bool
    @Binding var nameAlbum:String
    @Binding var descripAlbum:String
    @Binding var id_albumSelected:String
    @Binding var imgPortadaBind:String
    @Binding var pickturesList:[String]
    @State private var showConfirmation = false
    @State private var showColaboradores = false
    
    @State var urlPhotos = [String]()
    
    @State var loading = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    let columns = [
        GridItem(spacing: 10)
    ]
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                NewAlbumHeader(editorB: $editor, nameAlbum: $nameAlbum, imgPortda: $imgPortadaBind, descripAlbum: $descripAlbum, imges: $pickturesList, id_album: $id_albumSelected).frame(height: 280).padding(.top, 10)
                if editor {
                    Button("Seleccionar foto de portada \(editorVal.nameAlbum)"){
                        isShowingMediaPicker = true
                    }
                    .frame(width:300,height:180)
                    .background(.gray)
                    .opacity(0.6)
                    .cornerRadius(8)
                    .padding(.top, 0)
                    .foregroundColor(.white)
                    .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                    )
                    .mediaImporter(isPresented: $isShowingMediaPicker,
                                       allowedMediaTypes: .images,
                                       allowsMultipleSelection: false
                    ) { result in
                            switch result {
                            case .success(let urls):
                                self.urlsP = urls
                                imgPortada = "\(urls.first!)"
                                imgPortadaBind = "\(urls.first!)"
                            case .failure(let error):
                                print(error)
                                self.urlsP = []
                            }
                    }
                }
                
            }
            ZStack(alignment: .bottom) {
                HStack(){
                    //if avm.urlImagesAlbum.count > 0 {
                        ScrollView(.vertical) {
                            let colums2 = Array(repeating: GridItem(spacing:10), count: gridN)
                            LazyVGrid(columns: colums2, spacing: 10, content: {
                                ForEach(pickturesList, id: \.utf8CString) { url in
                                    GeometryReader {
                                        let size = $0.size
                                            AsyncImage(url: URL(string: url)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: size.width, height: size.height)
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            if editor {
                                                Button(action:{
                                                    
                                                }, label: {
                                                    Image(systemName: "multiply.circle.fill").frame(width:20, height: 20)
                                                }).padding(.all, 10)
                                                    .foregroundColor(.white)
                                            }
                                    }.frame(height:100)
                                    }
                            }).padding(10)
                        }
                //}
            }
            
            
            if editor {
                HStack(alignment: .center) {
                    Button(action: {
                        print(urlsP.count, id_albumSelected)
                        if urlsP.count == 0 {
                            loading = true
                            if self.id_albumSelected.isEmpty {
                                avm.createAlbum(nombre: nameAlbum, descripcion: descripAlbum, urlImg:"", descrip: descripAlbum,compation: {success in
                                    if success {
                                        editor = false
                                    } else {
                                        
                                    }
                                    loading = false
                                }, result: {id in
                                    self.id_albumSelected = id
                                })
                            } else {
                                avm.updateAlbum(album_id: id_albumSelected, nombre: nameAlbum, descripcion: descripAlbum, urlImg:"", descrip: descripAlbum,compation: {success in
                                    if success {
                                        editor = false
                                    } else {
                                        
                                    }
                                    loading = false
                                }, result: {id in
                                    self.id_albumSelected = id
                                })
                            }
                            
                            
                            return
                        }
                        loading = true
                        storageManager.upload(urls: urlsP, nameAlbum: nameAlbum){ success in
                            if success != "" {
                                if self.id_albumSelected.isEmpty {
                                    avm.createAlbum(nombre: nameAlbum, descripcion: descripAlbum, urlImg:success, descrip: descripAlbum,compation: {success in
                                        if success {
                                            editor = false
                                        } else {
                                            
                                        }
                                        loading = false
                                    }, result: {id in
                                        self.id_albumSelected = id
                                    })
                                } else {
                                    avm.updateAlbum(album_id: id_albumSelected, nombre: nameAlbum, descripcion: descripAlbum, urlImg:success, descrip: descripAlbum,compation: {success in
                                        if success {
                                            editor = false
                                        } else {
                                            
                                        }
                                    }, result: {id in
                                        self.id_albumSelected = id
                                    })
                                }
                            }
                            
                        }
                        
                    }, label: {
                        Text("Guardar")
                            .font(.system(size: 12))
                            .frame(width: 80, height: 35)
                            .foregroundColor(Color.white)
                    })
                    .background(Color.green)
                    .cornerRadius(38.5)
                    .padding(.all, 16)
                    .disabled(loading)

                    if loading {
                        ProgressView().foregroundColor(scheme == .dark ? .black : .white)
                    }
                    //.shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                    
                    Text("Modo editor").font(.system(size: 12))
                        .foregroundColor(scheme == .dark ? .black : Color.white)
                    
                    Button(action: {
                        if !isEdit {
                            nameAlbum = ""
                            presentationMode.wrappedValue.dismiss()
                            imgPortadaBind = ""
                        } else {
                            editor = false
                            if !imgPPrev.isEmpty {
                                imgPortada = imgPPrev
                                imgPortadaBind = imgPPrev
                                urlsP.append(URL(string:imgPPrev)!)
                            }
                            nameAlbum = nameAlbumPrev
                            descripAlbum = descripPrev
                        }
                    }, label: {
                        Text("Cancelar")
                            .font(.system(size: 12))
                            .frame(width: 80, height: 35)
                            .foregroundColor(Color.white)
                    })
                    .background(Color.red)
                    .cornerRadius(38.5)
                    .padding(.all, 16)
                    //.shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                }
                .background(scheme == .dark ? Color.white : .black)
                .cornerRadius(35)
                .padding(.horizontal, 26)
            } else {
                HStack(alignment: .center) {
                    Button(action: {
                        
                    }, label: {
                        Text("Privado")
                            .font(.system(size: 12))
                            .frame(width: 80, height: 35)
                            .foregroundColor(Color.white)
                    })
                    .background(.clear)
                    .cornerRadius(38.5)
                    .padding(.all, 16)
                    
                    Button(action: {
                        showConfirmation = true
                    }, label: {
                        Text("+")
                            .font(.system(size: 40))
                            .frame(width: 50, height: 45)
                            .foregroundColor(Color(hex: "9d9d9d"))
                            .padding(.bottom, 4)
                    })
                    .background(Color(hex: "f0f0f0"))
                    .cornerRadius(38.5)
                    .mediaImporter(isPresented: $isShowingMediaPicker,
                                   allowedMediaTypes: .all,
                                   allowsMultipleSelection: false) { result in
                        switch result {
                        case .success(let urls):
                            self.urls = urls
                            storageManager.upload(urls: urls, nameAlbum: editorVal.nameAlbum){ success in
                                if !success.isEmpty {
                                    avm.addMedia(urlImg: success, id_album: id_albumSelected, responseSuccess: { success in
                                        avm.getAlbumDetail(idAlbum: id_albumSelected, imagenes: { images in
                                            pickturesList = images
                                        })
                                    })
                                }
                            }
                        case .failure(let error):
                            print(error)
                            self.urls = []
                        }
                    }
                    //.shadow(color: Color.black.opacity(0.3)
                    
                    Button(action: {
                        if gridN == 2 {
                            gridN = 3
                        } else {
                            gridN = 2
                        }
                    }, label: {
                        Image(systemName: gridN == 3 ? "square.grid.2x2.fill" : "rectangle.grid.3x2.fill")
                            .font(.system(size: 22))
                            .frame(width: 80, height: 35)
                            .foregroundColor(Color.white)
                    })
                    .background(.clear)
                    .cornerRadius(38.5)
                    .padding(.all, 16)
                    //.shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                }
                .background(Color(hex: "#9d9d9d"))
                .cornerRadius(35)
                .padding(.horizontal, 26)
            }
            
        }.navigationBarBackButtonHidden(true)
            .snackbar(isShowing: $showSnack, title: "Debe seleccionar una foto de portada", style: .warning)
            .onAppear{
                print("url desaparece:",urlsP)
                
                if !imgPortadaBind.isEmpty {
                    urlsP.append(URL(string:imgPortadaBind)!)
                    imgPPrev = imgPortadaBind
                }
                nameAlbumPrev = nameAlbum
                descripPrev = descripAlbum
                
                if !id_albumSelected.isEmpty {
                    avm.getAlbumDetail(idAlbum: id_albumSelected, imagenes: { imgs in
                        pickturesList = imgs
                    })
                    
                }
            }
            .confirmationDialog("Agrega o sube", isPresented: $showConfirmation) {
                Button("Colaboradores") {
                    showColaboradores = true
                }
                Button("Foto/Video") {
                    isShowingMediaPicker = true
                }
                Button("Cancel", role: .cancel) {
                    
                }
            }
            .sheet(isPresented: $showColaboradores, content: {
                InviteCollaboratorsScreen(id_album: $id_albumSelected)
            })
    }
    
}
}

struct NewAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewAlbumScreen(isEdit:.constant(false), editor: .constant(false), nameAlbum: .constant(""), descripAlbum: .constant(""), id_albumSelected: .constant(""), imgPortadaBind: .constant(""), pickturesList: .constant(["https://firebasestorage.googleapis.com:443/v0/b/stickjoy-swiftui.appspot.com/o/AJVuYmOk0AUCNNuMY9le%2FIMG_0005.jpeg?alt=media&token=a48f40ce-01f1-44da-963b-b32882dce548"]))
    }
}

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }
        
        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }
        
        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }
        
        // Scanner creation
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        if string.count == 2 {
            let mask = 0xFF
            
            let g = Int(color) & mask
            
            let gray = Double(g) / 255.0
            
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
            
        } else if string.count == 4 {
            let mask = 0x00FF
            
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0
            
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
            
        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
            
        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0
            
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            
        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}

