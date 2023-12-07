//
//  ElsesAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre de Lista de Requerimientos: 16. Pantalla de Album Ajeno
//  Paulo: Es casi igual que AlbumScreen solo con los botones de encabezado que se ven en FIGMA. Ponerlos a la altura igual que ElsesProfileScreen solo que el botón de anclar se reemplaza por el de Image(systemName: "ellipsis.circle.fill") que abre la pantalla de AlbumInfoPanelScreen.swift

import SwiftUI
import SDWebImageSwiftUI
import MediaPicker

struct ElsesAlbumScreen: View {
    @ObservedObject var avm:AlbumViewModel
    @StateObject var homeData = ProfileViewModel()
    @StateObject var storageManager = StorageManager()
    @State var gridN = 3
    @Binding var id_album:String
    @Binding var nameAlbum:String
    @Binding var descripAlbum:String
    @Binding var username:String
    @Binding var imgPortada:String
    @Binding var id_user:String
    @Binding var pickturesList:[pickture]
    @State var isFullScreen = false
    @State var img = ""
    @State var isInfo = false
    @State var indexScroll = 0
    @Environment (\.colorScheme) var scheme
    @Environment (\.dismiss) var dismiss
    @State var lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? ""
    @Binding var iColaborator:Bool
    @State var editColaborator = false
    @State var isUpload = false
    @State var urlFileUpload = ""
    @State var selectFile = false
    @State var alertConfirm = false
    @State var user_id = ""
    @State var mensaje = ""
    @State var showAlert = false
    @State var indexSelected = 0
    @Binding var proceso : Bool
    @Binding var album_up : String
    @Binding var porcentaje:Float
    @Binding var items_up:Int
    @Binding var isCollaborator:Bool
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack{
                        LazyVStack(pinnedViews: [.sectionHeaders]){
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
                                        portada(offset: offset, imgPortada: $imgPortada)
                                    }
                                )
                            }
                            .frame(height: 200)
                            Section(header:ElsesAlbumHeader(nameAlbum: $nameAlbum, descripAlbum: $descripAlbum, username: $username, imgPortada: $imgPortada, isInfo: $isInfo, isColaborator: $isCollaborator).frame(height:180)){
                                NavigationLink(destination: MySelectionScreen(stm: storageManager, shouldPopToRootView: $selectFile, isAlbumRoot: .constant(true), albumSelected: AlbumSelectView(id_album: id_album, name: nameAlbum, descrip: descripAlbum, url: imgPortada, userName: username), proceso: $proceso, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload: $selectFile), isActive: $selectFile) {
                                    EmptyView()
                                }
                                if id_album == album_up {
                                    HStack {
                                        if proceso {
                                            Text(lenguaje == "es" ? "Subiendo \(items_up) elementos" : "Uploading \(items_up) elements")
                                                .padding()
                                        } else {
                                            Text(lenguaje == "es" ? "¡Subiste \(items_up) exitosamente" : "You uploaded \(items_up) elements succesfully!")
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
                                    .padding(8)
                                }
                                if !editColaborator {
                                    ElseAlbumBody(editar: $editColaborator, avm: avm, pickturesList: $pickturesList)
                                } else {
                                    ColaboratorAlbumBody(avm: avm, id_albumSelected: $id_album, pickturesList: $avm.picktureList)
                                }
                            }
                        }.padding(.top, 10)
                    }
                }
                .overlay(
                    (scheme == .dark ? Color.black : Color.white)
                    //Esta parte no sé como cambiarla para que funcione igual
                        .frame(height:UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .ignoresSafeArea(.container, edges: .top)
                    //Esto es para que ignore la parte de arriba de la pantalla.
                        .opacity(homeData.offset > 180 ? 1 : 0)
                    , alignment: .top
                )
            }
            
            ZStack(alignment: .bottom) {
                HStack{
                    if !editColaborator {
                        Button(action: {
                            selectFile = true
                        }, label: {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                Text(lenguaje == "es" ? "Subir" : "Upload").font(.system(size: 12))
                                    .frame(width: 80, height: 35)
                            }
                        })
                        .disabled(proceso)
                    }
                    if editColaborator {
                        Button(action: {
                            editColaborator = false
                        }, label: {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text(lenguaje == "es" ? "Listo" : "Ok").font(.system(size: 12))
                                    .frame(width: 80, height: 35)
                            }
                        })
                    }
                }
                .opacity(iColaborator ? 1.0 : 0)
                .padding(.horizontal, 20)
            }
        }
        .onAppear{
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? ""
            user_id = UserDefaults.standard.string(forKey: "id") ?? ""
            avm.getAlbumDetail(idAlbum: id_album)
        }
        .fullScreenCover(isPresented: $isFullScreen, content: {
            FullSizeItem(img: $img, name_album: $nameAlbum, username: $username, album_descrip: $descripAlbum, profileImg: .constant(""), indexScroll: $indexScroll, images: $pickturesList)
        })
        .fullScreenCover(isPresented: $isInfo, content: {
            AlbumInfoPanelScreen(id_album:$id_album, id_user: $id_user, lenguaje: $lenguaje, isColaborator: $iColaborator, editC: $editColaborator)
        })
        .sheet(isPresented: $isUpload, content: {
            UploadPictureOrVideoScreen(avm: avm, urlImgOrVideo: $urlFileUpload, id_album: $id_album, name_album: $nameAlbum)
        })
        /*.mediaImporter(isPresented: $selectFile, allowedMediaTypes: .all, allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                self.urlFileUpload = "\(urls.first!)"
                self.isUpload = true
            case .failure(let error):
                print(error)
                self.urlFileUpload = ""
            }
        }*/
    }
    
    //struct ElsesAlbumScreen_Previews: PreviewProvider {
      //  static var previews: some View {
            //ElsesAlbumScreen(avm: AlbumViewModel(), id_album: .constant(""), nameAlbum: .constant("Nuevo album con nombre muy largo"), descripAlbum: .constant("Descripcion album"), username: .constant("username"), imgPortada: .constant(""), id_user: .constant(""), pickturesList: .constant([]), iColaborator: .constant(false))
        //}
   // }
    
    struct anuncio: View {
        @Binding var index:Int
        @Binding var alto:Double
        @Binding var ancho:Double
        var body: some View {
            VStack {
                if index % 9 == 0 {
                    if index > 1 {
                        BannerAlbumViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716", ancho: 250, alto: alto)
                    }
                }
            }
        }
    }
    struct portada: View {
        var offset: CGFloat
        @Binding var imgPortada: String
        var body: some View {
            WebImage(url: URL(string: imgPortada))
                .resizable()
                .placeholder(Image("stickjoyLogoBlue"))
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset: 0))
                .cornerRadius(2)
                .offset(y:(offset > 0 ? -offset: 0))
                .background()
        }
    }
    
    struct imagenAlbum: View {
        var index:Int
        var tipo:Int
        var image:UIImage
        var width:Double
        var height:Double
        var duration:String
        var editColaborator:Bool
        var url:String
        var isMyFile:Bool
        
        @Binding var img:String
        @Binding var isFullScreen:Bool
        @Binding var indexScroll:Int
        @Binding var indexSelected:Int
        @Binding var alertConfirm:Bool
        
        var body: some View {
            if index % 9 == 0 && index > 1  {
                anuncio(index: .constant(index), alto: .constant(height), ancho: .constant(.infinity))
            } else {
                if tipo == 2 {
                    ZStack(alignment: .topTrailing) {
                        ZStack(alignment: .bottomTrailing){
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: height)
                                .cornerRadius(10)
                                .onTapGesture {
                                    if !editColaborator {
                                        img = url
                                        isFullScreen = true
                                        indexScroll = index
                                    }
                                }
                            Text(duration)
                                .padding(4)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        if editColaborator {
                            Button(action:{
                                indexSelected = index
                                alertConfirm = true
                            }, label: {
                                Image(systemName: "multiply.circle.fill").frame(width:30, height: 30).font(.title)
                            })
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .opacity(isMyFile ? 1.0 : 0)
                        }
                    }
                } else {
                    ZStack(alignment: .topTrailing) {
                        WebImage(url: URL(string: url))
                            .resizable()
                            .placeholder(Image("stickjoyLogo"))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .cornerRadius(10)
                            .onTapGesture {
                                if !editColaborator {
                                    img = url
                                    isFullScreen = true
                                    indexScroll = index
                                }
                            }
                        if editColaborator {
                            Button(action:{
                                indexSelected = index
                                alertConfirm = true
                            }, label: {
                                Image(systemName: "multiply.circle.fill").frame(width:30, height: 30).font(.title)
                            })
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .opacity(isMyFile ? 1.0 : 0)
                        }
                    }
                }
            }
        }
    }
    
    struct ElsesAlbumHeader: View {
        @Environment (\.colorScheme) var scheme
        @Environment (\.dismiss) var dismiss
        @Binding var nameAlbum:String
        @Binding var descripAlbum:String
        @Binding var username:String
        @Binding var imgPortada:String
        @Binding var isInfo:Bool
        @Binding var isColaborator:Bool
        var body: some View{
            ZStack(alignment: .top) {
                (scheme == .dark ? Color.black : Color.white)
                VStack(alignment: .leading, spacing: 8) {
                    //Layout de botones de regresar y editar
                    HStack {
                        //Botón de regresar
                        Button(action: {
                            // Add your action here
                            dismiss()
                            isColaborator = false
                        }) {
                            Image(systemName: "arrow.backward.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .cornerRadius(20)
                        }
                        //Añadí este frame para que el nombre de album quepa
                        .frame(width: 20, height: 20)
                        Spacer()
                        //Botón para entrar a editor de album
                        Button(action: {
                            // Add your action here
                            isInfo = true
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title).foregroundColor(.gray)
                                .cornerRadius(20)
                        }
                        //Añadí este frame para que el nombre de album quepa
                        .frame(width: 20, height: 20)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                    //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                    //Título de álbum
                    HStack {
                        //Busca el título default del álbum
                        Text(nameAlbum)
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }.padding(.leading,20)
                        .padding(.trailing, 20)
                        .padding(.top, 5)
                    
                    //Muestra administrador del álbum
                    Text(username.replacingOccurrences(of: " ", with: ""))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    Text(descripAlbum)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                }
                .padding(0)
                .edgesIgnoringSafeArea(.top)
            }.edgesIgnoringSafeArea(.horizontal)
        }
    }
}
