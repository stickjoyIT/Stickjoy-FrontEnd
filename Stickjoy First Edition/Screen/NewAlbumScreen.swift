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
import SDWebImageSwiftUI
import Lottie

@available(iOS 16.0, *)
struct NewAlbumScreen: View {
    @State private var isRefreshing = false
    @StateObject var homeData = ProfileViewModel()
    @State var gridN = 3
    @State private var colors:[Color] = [.blue, .black, .gray, .green, .yellow]
    @State private var draggItem: String?
    @Environment (\.colorScheme) var scheme
    @StateObject var storageManager = StorageManager()
    @ObservedObject var editorVal = SetEditor()
    @ObservedObject var avm:AlbumViewModel
    @ObservedObject var uvm:UsuariosViewModel
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
    @Binding var pickturesList:[pickture]
    @Binding var lenguaje:String
    @Binding var privacy:Int
    @State private var showConfirmation = false
    @State private var showColaboradores = false
    @State private var showPrivacy = false
    @State var urlPhotos = [String]()
    @State var loading = false
    @State var imgUrl = ""
    @State var fullSize = false
    @State var username = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var profileImg = UserDefaults.standard.string(forKey: "portada") ?? ""
    @State var id_user = UserDefaults.standard.string(forKey: "id") ?? ""
    @State var indexScroll = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    let columns = [
        GridItem(spacing: 10)
    ]
    @State var isAdminPanel = false
    @State var isUpload = false
    @State var urlUploadMedia = ""
    @State var alertConfirm = false
    @State var mensaje = ""
    @State var showAlert = false
    @State var indexImgSelected = 0
    @Binding var proceso:Bool
    var userOwner:String
    @Binding var items_up:Int
    @Binding var album_up:String
    @Binding var rootIsActive:Bool
    @Binding var isUploadN:Bool
    @Binding var porcentaje:Float
    @Binding var isActive:Bool
    @State var showSnackBar = false
    @State var dismissP = false
    @Binding var seeIt: Bool
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack(pinnedViews:[.sectionHeaders]) {
                            //Imagen de Encabezado retractil al dar scroll
                            GeometryReader { reader -> AnyView in
                                let offset = reader.frame(in: .global).minY
                                //Esto es para que ignore la parte de arriba de la pantalla.
                                if -offset >= 0{
                                    DispatchQueue.main.async {
                                        self.homeData.offset = -offset
                                    }
                                }
                                //Imagen de encabezado
                                return AnyView(
                                    ZStack(alignment:.top) {
                                        WebImage(url: URL(string: imgPortadaBind))
                                            .resizable()
                                            .placeholder(Image("stickjoyLogoBlue"))
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                                            .cornerRadius(2)
                                            .offset(y:(offset > 0 ? -offset: 0))
                                            .background()
                                        if editor {
                                            Button(lenguaje == "es" ? "Seleccionar foto de portada" : "Select cover photo"){
                                                isShowingMediaPicker = true
                                            }
                                            .frame(width:300,height:180)
                                            .background(.gray)
                                            .opacity(0.6)
                                            .cornerRadius(8)
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
                                            .padding(.top, 40)
                                            .offset(y:(offset > 0 ? -offset: 0))
                                        }
                                    }
                                )
                            }
                            .frame(height: 200)
                            Section(header: NewAlbumHeader(editorB: $editor, nameAlbum: $nameAlbum, imgPortda: $imgPortadaBind, descripAlbum: $descripAlbum, imges: .constant([]), id_album: $id_albumSelected, userOwner: userOwner, isActive: $isActive, seeIt: $seeIt).frame(height: editor ? 180 : 180)) {
                                let colums2 = Array(repeating: GridItem(spacing:10), count: gridN)
                                NavigationLink(destination: MySelectionScreen(stm: storageManager, shouldPopToRootView: $isUploadN, isAlbumRoot: .constant(true), albumSelected: AlbumSelectView(id_album: id_albumSelected, name: nameAlbum, descrip: descripAlbum, url: imgPortadaBind, userName: userOwner), proceso: $proceso, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload: $isUploadN), isActive: $isUploadN) {
                                    EmptyView()
                                }
                                if !album_up.isEmpty && id_albumSelected == album_up {
                                    HStack {
                                        if proceso {
                                            Text(lenguaje == "es" ? "Subiendo \(items_up) elementos" : "Uploading \(items_up) elements")
                                                .padding()
                                        } else {
                                            Text(lenguaje == "es" ? "¡Subiste \(items_up) elementos exitosamente" : "You uploaded \(items_up) elements succesfully!")
                                                .padding()
                                        }
                                        //.foregroundColor(.black)
                                        Spacer()
                                        if proceso {
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 5.0)
                                                    .opacity(0.3)
                                                    .foregroundColor(Color.blue)
                                                    .frame(width: 40, height:40)
                                                
                                                Circle()
                                                    .trim(from: 0.0, to: CGFloat(min(porcentaje, 100)) / 100)
                                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                                                    .foregroundColor(Color.yellow)
                                                    .rotationEffect(Angle(degrees: -90))
                                                    .animation(.easeInOut)
                                                    .frame(width: 40, height:40)
                                                
                                                Text("\(Int(porcentaje)) %")
                                                    .font(.system(size: 8))
                                                    .fontWeight(.bold)
                                            }
                                            .padding(.trailing, 8)
                                        } else {
                                            Button("Ok"){
                                                album_up = ""
                                                UserDefaults.standard.set("",forKey: "album_update")
                                            }
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(scheme == .dark ? .black : .white)
                                    .cornerRadius(16)
                                    .padding(16)
                                    .padding(.horizontal, 8)
                                }
                                if !editor {
                                    ElseAlbumBody(editar:.constant(false),avm: avm, pickturesList: $pickturesList)
                                }else {
                                    LazyVGrid(columns: colums2, spacing: 10, content: {
                                        ForEach(pickturesList, id: \.id) { img in
                                            GeometryReader {
                                                let size = $0.size
                                                /*ZStack(alignment: .topLeading){
                                                 ImageViewC(url: url.url, imgUrl: $imgUrl, index: index, indexScroll: $indexScroll, size: size, fullSize: $fullSize, tipo: url.tipo, image: url.image, editor: $editor, duration:url.duration)
                                                 .draggable(url.url) {
                                                 ImageViewC(url: url.url, imgUrl: $imgUrl, index: index, indexScroll: $indexScroll, size: size, fullSize: $fullSize, tipo: url.tipo, image: url.image, editor: $editor, duration:url.duration)
                                                 .frame(width:size.width, height: size.height)
                                                 .onAppear{
                                                 draggItem = url.id_img
                                                 }
                                                 }
                                                 .dropDestination(for:String.self){items,location in
                                                 return false
                                                 } isTargeted: { status in
                                                 if let draggItem, status, draggItem != url.id_img {
                                                 if let sourceIndex = pickturesList.firstIndex(where: { $0.id_img == draggItem}),let destinationIndex = pickturesList.firstIndex(where: {$0.id_img == url.id_img}) {
                                                 withAnimation(.default){
                                                 print("---- move ----")
                                                 let oldOrder = pickturesList[sourceIndex].order
                                                 let newOrder = pickturesList[destinationIndex].order
                                                 pickturesList[sourceIndex].order = newOrder
                                                 pickturesList[destinationIndex].order = oldOrder
                                                 
                                                 let sourceItem = pickturesList.remove(at: sourceIndex)
                                                 pickturesList.insert(sourceItem, at: destinationIndex)
                                                 let ordenado = pickturesList.sorted{ $0.order > $1.order }
                                                 print("nuevo orden:",ordenado)
                                                 pickturesList = ordenado
                                                 avm.reorderMedia(picktures: ordenado, id_album: id_albumSelected, user: id_user)
                                                 avm.createMatriz(pickturesList: pickturesList)
                                                 }
                                                 }
                                                 }
                                                 }
                                                 if editor {
                                                 Button(action:{
                                                 alertConfirm = true
                                                 indexImgSelected = index
                                                 }, label: {
                                                 Image(systemName: "trash.circle.fill").frame(width:30, height: 30).font(.title)
                                                 }).padding(.all, 10)
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
                                                 }*/
                                                ZStack(alignment: .topLeading){
                                                    ImageOrVideo(tipo: img.tipo, url: img.url, alto: 0.0, size: size)
                                                        .onDrag({
                                                            avm.currentPage = img
                                                            return NSItemProvider(contentsOf: URL(string: "\(img.id)"))!
                                                        })
                                                        .onDrop(of: [.url], delegate: DropViewDelegate(pageData: avm, page: img))
                                                    if editor {
                                                        Button(action:{
                                                            
                                                            if let indexS = pickturesList.firstIndex( where: {$0.id_img == img.id_img}) {
                                                                alertConfirm = true
                                                                indexImgSelected = indexS
                                                            }
                                                        }, label: {
                                                            Image(systemName: "trash.circle.fill").frame(width:30, height: 30).font(.title)
                                                        }).padding(.all, 10)
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
                                                }
                                                
                                                
                                            }.frame(height:100)
                                        }
                                    }).padding(10)
                                }
                            }
                        }
                    }.overlay(
                        (scheme == .dark ? Color.black : Color.white)
                        //Esta parte no sé como cambiarla para que funcione igual
                            .frame(height:UIApplication.shared.windows.first?.safeAreaInsets.top)
                            .ignoresSafeArea(.container, edges: .top)
                        //Esto es para que ignore la parte de arriba de la pantalla.
                            .opacity(homeData.offset > 180 ? 1 : 0)
                        , alignment: .top
                    ).refreshable(action: {
                        avm.getAlbumDetail(idAlbum: id_albumSelected)
                    })
                }
                .navigationBarHidden(true)
                .padding(.bottom, 20)
            }
            if !seeIt {
            ZStack(alignment: .bottom) {
                if loading {
                    Spacer()
                    Text(lenguaje == "es" ? "Guardando..." : "Saving...").font(.system(size: 12))
                        .foregroundColor(scheme == .dark ? .white : .black)
                    
                    Spacer()
                } else {
                    if editor {
                        HStack(alignment: .center) {
                            Button(action: {
                                if urlsP.count == 0 {
                                    loading = true
                                    if self.id_albumSelected.isEmpty {
                                        avm.createAlbum(nombre: nameAlbum, descripcion: descripAlbum, urlImg:"", descrip: descripAlbum,compation: {
                                            success in
                                            if success {
                                                editor = false
                                            } else {
                                                
                                            }
                                            loading = false
                                            //self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                                        }, result: {id in
                                            self.id_albumSelected = id
                                        })
                                    } else {
                                        avm.updateAlbum(album_id: id_albumSelected, nombre: nameAlbum, descripcion: descripAlbum, urlImg:"", descrip: descripAlbum, privacy: privacy, compation: {success in
                                            if success {
                                                editor = false
                                            } else {
                                                
                                            }
                                            loading = false
                                            //self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                                        }, result: {id in
                                            self.id_albumSelected = id
                                        })
                                    }
                                    return
                                } else {
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
                                                    //self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                                                }, result: {id in
                                                    self.id_albumSelected = id
                                                })
                                            } else {
                                                avm.updateAlbum(album_id: id_albumSelected, nombre: nameAlbum, descripcion: descripAlbum, urlImg:success, descrip: descripAlbum, privacy: privacy,compation: {success in
                                                    if success {
                                                        editor = false
                                                    } else {
                                                        
                                                    }
                                                    loading = false
                                                }, result: {id in
                                                    self.id_albumSelected = id
                                                })
                                            }
                                        } else {
                                            loading = false
                                        }
                                    }
                                }
                            }, label: {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .frame(width: 85, height: 35)
                                    Text(lenguaje == "es" ? "Listo" : "Ok").font(.system(size: 12))
                                }
                            })
                            if !isEdit {
                                Spacer()
                                Button(action: {
                                    if !isEdit {
                                        nameAlbum = ""
                                        isActive = false
                                        //presentationMode.wrappedValue.dismiss()
                                        imgPortadaBind = ""
                                    }
                                }, label: {
                                    VStack {
                                        Image(systemName: "x.circle.fill")
                                            .frame(width: 85, height: 35)
                                        Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                                            .font(.system(size: 12))
                                    }
                                })
                            }
                            /**/
                        }
                        .cornerRadius(35)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 15)
                    } else {
                        Spacer()
                        HStack(alignment: .center) {
                            Button(action: {
                                showPrivacy = true
                            }, label: {
                                VStack {
                                    Image(systemName: "lock")
                                    switch privacy {
                                    case 0:
                                        Text(lenguaje == "es" ? "Privado" : "Private")
                                            .font(.system(size: 12))
                                            .frame(width: 80, height: 35)
                                    case 1:
                                        Text(lenguaje == "es" ? "Amigos" : "Friends")
                                            .font(.system(size: 12))
                                            .frame(width: 80, height: 35)
                                    case 2:
                                        Text(lenguaje == "es" ? "Público" : "Public")
                                            .font(.system(size: 12))
                                            .frame(width: 80, height: 35)
                                    default:
                                        Text(lenguaje == "es" ? "Privado" : "Private")
                                            .font(.system(size: 12))
                                            .frame(width: 80, height: 35)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                                .padding(.top, 5)
                            })
                            .background(scheme == .dark ? Color(hex: "#000") : .white)
                            Spacer()
                            Button(action: {
                                showConfirmation = true
                            }, label: {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text(lenguaje == "es" ? "Agregar" : "Add").font(.system(size: 12))
                                        .frame(width: 80, height: 35)
                                        .padding(.bottom, 5)
                                }.padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                                    .padding(.top, 5)
                                    .badge(proceso ? 1 : 0)
                            })
                            .background(scheme == .dark ? Color(hex: "#000") : .white)
                            .disabled(proceso)
                            
                            Spacer()
                            Button(action: {
                                isAdminPanel = true
                            }, label: {
                                VStack {
                                    Image(systemName: "slider.horizontal.3")
                                    Text("Panel").font(.system(size: 12))
                                        .frame(width: 80, height: 35)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                                .padding(.top, 5)
                            })
                            .background(scheme == .dark ? Color(hex: "#000") : .white)
                        }
                        .background(scheme == .dark ? .black : .white)
                        .frame(height: 10)
                        .padding(.bottom, 10)
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                if !imgPortadaBind.isEmpty {
                    urlsP.append(URL(string:imgPortadaBind)!)
                    imgPPrev = imgPortadaBind
                }
                nameAlbumPrev = nameAlbum
                descripPrev = descripAlbum
                
                if !id_albumSelected.isEmpty {
                    
                }
                id_user = UserDefaults.standard.string(forKey: "id") ?? ""
            }
            .onChange(of: proceso){ val in
                print("proceso: \(val)")
                items_up = UserDefaults.standard.integer(forKey: "items_up")
                if !val && id_albumSelected == album_up {
                    avm.getAlbumDetail(idAlbum: id_albumSelected)
                }
            }
            .confirmationDialog("Agrega o sube", isPresented: $showConfirmation) {
                Button(lenguaje == "es" ? "Contenido" : "Content") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if proceso {
                            showSnackBar = true
                        } else {
                            isUploadN = true
                        }
                        print(isUploadN)
                    }
                }
                Button(lenguaje == "es" ? "Colaboradores" : "Collaborators") {
                    showColaboradores = true
                }
                
                Button(lenguaje == "es" ? "Cancelar" : "Cancel", role: .cancel) {
                    
                }
            }
            .sheet(isPresented: $showColaboradores, content: {
                InviteCollaboratorsScreen(id_album: $id_albumSelected, uvm:uvm, avm: avm, lenguaje: $lenguaje, colaboradores: $avm.colaboradores)
            })
            .sheet(isPresented: $showPrivacy, content: {
                AlbumPrivacyScreen(lenguaje: $lenguaje, privacy: $privacy, id_album: $id_albumSelected)
            })
            .fullScreenCover(isPresented: $fullSize, content: {
                FullSizeItem(img: $imgUrl, name_album: $nameAlbum, username: $username, album_descrip: $descripAlbum, profileImg: $profileImg, indexScroll: $indexScroll, images: .constant(pickturesList))
            })
            .fullScreenCover(isPresented: $isAdminPanel, content: {
                AdminPanelScreen(avm:AlbumViewModel(), uvm:UsuariosViewModel() ,id_album: $id_albumSelected, lenguaje: $lenguaje)
            })
            .sheet(isPresented:$isUpload, content: {
                UploadPictureOrVideoScreen(avm: avm, urlImgOrVideo: $urlUploadMedia, id_album: $id_albumSelected, name_album: $nameAlbum)
            })
        }
            
        }
        .snackbar(isShowing: $showSnackBar , title: Text(""), text: Text(lenguaje == "es" ? "Espere a que finalice la carga para agregar" : "Wait for the upload to finish"), style: .custom(Color(hex: "FFD966")), dismissOnTap: true, dismissAfter: 5)
        
    }
}

struct ImageViewC: View {
    var url:String
    @Binding var imgUrl:String
    var index:Int
    @Binding var indexScroll:Int
    var size:CGSize
    @Binding var fullSize:Bool
    var tipo:Int
    var image:UIImage
    @Binding var editor:Bool
    var duration:String
    var body: some View {
        ZStack(alignment:.bottom) {
            HStack {
                if editor {
                    Spacer()
                    Image(systemName: "arrow.up.arrow.down")
                        .frame(width:30, height: 30)
                        .font(.title)
                }
            }
            VStack {
                if tipo == 1 {
                    AnimatedImage(url: URL(string: url))
                        .indicator(SDWebImageActivityIndicator.medium)
                        .transition(.fade)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !editor {
                                imgUrl = url
                                indexScroll = index
                                fullSize = true
                            }
                        }
                    
                } else {
                    ZStack(alignment: .bottomLeading) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:size.width, height: size.height)
                            .cornerRadius(10)
                            .onTapGesture {
                                if !editor {
                                    imgUrl = url
                                    indexScroll = index
                                    fullSize = true
                                }
                            }
                        Text(duration)
                            .padding(4)
                            .foregroundColor(.white)
                            //.background(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
        }
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

struct Refreshable: ViewModifier {
    @Binding var isRefreshing: Bool
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    if self.isRefreshing {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                                .foregroundColor(Color.blue)
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(Color.white)
                        .onAppear {
                            self.action()
                        }
                    }
                }
            )
    }
}

extension View {
    func pullToRefresh(isRefreshing: Binding<Bool>, action: @escaping () -> Void) -> some View {
        return self.modifier(Refreshable(isRefreshing: isRefreshing, action: action))
    }
}

struct DropViewDelegate:DropDelegate {
    var pageData:AlbumViewModel
    var page : pickture
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = pageData.picktureList.firstIndex { (page) -> Bool in
            return page.id == pageData.currentPage?.id
        } ?? 0
        
        let toIndex = pageData.picktureList.firstIndex{ (page) -> Bool in
            return page.id == self.page.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation(.easeIn) {
                let itemS = pageData.picktureList.remove(at: fromIndex)
                pageData.picktureList.insert(itemS, at: toIndex)
                pageData.reorderMedia(picktures: pageData.picktureList, id_album: page.album_id, user: page.user_id)
                pageData.createMatriz(pickturesList: pageData.picktureList)
            }
        }
    }
}

struct ImageOrVideo: View {
    var tipo:Int
    var url:URL
    var alto:Double
    var size:CGSize
    var vm = AlbumViewModel()
    var body: some View {
        VStack {
            if tipo == 1 {
                ZStack(alignment: .bottomTrailing) {
                    WebImage(url: url)
                        .resizable()
                        .placeholder(Image("stickjoyLogo"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width:size.width, height: size.height)
                        .cornerRadius(15)
                    
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                
            } else {
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: (vm.getVideoThumbnail(url: url) ?? UIImage(named: "stickjoyLogo"))!)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:size.width, height: size.height)
                        .cornerRadius(10)
                    
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
