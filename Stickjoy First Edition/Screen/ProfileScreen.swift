//
//  DefaultProfileScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Nombre de Lista de Requerimientos: 6. Pantalla de Perfil de Usuario
//  Paulo: scroll de albums. la info está conectada a carpeta: Model/Profile Info y su respectivo archivo.
//  ¿Qué falta?: Imagen de album te lleve a álbum, conectar botón de editar perfil, te debe llevar al AlbumScreen de ese album.


import SwiftUI
import SDWebImageSwiftUI
import MediaPicker
import FirebaseStorage
import FirebaseMessaging
import Firebase

@available(iOS 16.0, *)
struct ProfileScreen: View {
    //Esto se manda a llamar para que la imagen del encabezado ignore las safe areas de arriba
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @StateObject var homeData = ProfileViewModel()
    @Binding var logueado:Bool
    //var storageManager = StorageManager()
    @ObservedObject var uvm = UsuariosViewModel()
    @State var isActive = false
    @State var editorP = false
    @State var id_album = ""
    @State var changeUpdates = false
    @State var Albums = [AlbumInfo]()
    @ObservedObject var avm = AlbumViewModel()
    @ObservedObject var editorB = SetEditor()
    @Environment (\.colorScheme) var scheme
    @Environment (\.dismiss) var dismiss
    @Binding var lenguaje:String
    @State var pickturesList = [pickture]()
    @State var isShowingMediaPicker = false
    @State var loading = false
    @State var nameUser = ""
    @State var username = ""
    @State var descrip = ""
    @State var portada =  ""
    @State var privacy = 0
    @State var alertRegister = false
    @EnvironmentObject var stm:StorageManager
    @Binding var proceso:Bool
    @State var album_update = ""
    @State var items_update = 0
    @State var isActiveRoot : Bool = false
    @Binding var porcentaje : Float
    @State var isUploadN = false
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                //Header pinneado
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders], content: {
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
                                WebImage(url: URL(string: editorB.imgPortadaP))
                                    .resizable()
                                    .placeholder(Image("stickjoyLogo"))
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: 200 + (offset > 0 ? offset: 0))
                                    .cornerRadius(2)
                                    .offset(y:(offset > 0 ? -offset: 0))
                                if editorP {
                                    Button(lenguaje == "es" ? "Seleccionar foto de perfil" : "Select profile picture"){
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
                                            stm.upload(urls: urls, nameAlbum: ""){ success in
                                                portada = success
                                                editorB.imgPortadaP = success
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                }
                                
                                
                            }
                        )
                    }
                    .frame(height: 200)
                    // Albums
                    Section(header: ProfileHeader(name: $nameUser, username:$username, description:$descrip, editor: $editorP)) {
                        //For each para que aparezcan los álbumes del usuario
                        if Albums.count > 0 {
                            ForEach(Albums){albums in
                                // El albums se repite aquí:
                                ProfileBody(albumsinfo: albums, avm: avm, uvm: uvm, albumName: $editorB.nameAlbum, albumDecripcion: $editorB.descripAlbum, imgPortada: $editorB.imgPortada, editor: $editorB.editor, editorP: $editorP, albums: $Albums, privacy: $privacy, lenguaje: $lenguaje, pickturesList: $avm.picktureList, proceso: $proceso, porcentaje: $porcentaje).padding(.all, 10)
                            }
                        } else {
                            HStack {
                                Spacer()
                                VStack(alignment: .center, spacing: 10) {
                                    Text(lenguaje == "es" ? "Crear un álbum" : "Create an album")
                                    Button(action: {
                                        editorB.editor = true
                                        editorB.nameAlbum = lenguaje == "es" ? "Nombre del álbum" : "Album name"
                                        editorB.descripAlbum = lenguaje == "es" ? "¡Bienvenid@ a mi nuevo album de Stickjoy!" : "Welcome tu my new Stickjoy album!"
                                        isActive = true
                                    }, label: {
                                        Text("+")
                                            .navigationBarBackButtonHidden(true)
                                            .frame(width: 150,height: 150)
                                            .background(.gray)
                                            .opacity(0.2)
                                            .cornerRadius(10)
                                    })
                                    .fullScreenCover(isPresented: $isActive, onDismiss: {
                                        avm.getAlbumList(compation: { albs in
                                            Albums = albs
                                        }, responseData: { response in
                                            
                                        })
                                    }, content: {
                                        NewAlbumScreen(avm: avm, uvm: uvm, isEdit: .constant(false), editor: $editorB.editor, nameAlbum: $editorB.nameAlbum, descripAlbum: $editorB.descripAlbum, id_albumSelected: $id_album, imgPortadaBind: $editorB.imgPortada, pickturesList: $avm.picktureList, lenguaje: $lenguaje, privacy: $privacy, proceso: $proceso, userOwner: UserDefaults.standard.string(forKey: "username") ?? "", items_up: $items_update, album_up: $album_update, rootIsActive: $isActiveRoot, isUploadN: $isUploadN, porcentaje: $porcentaje, isActive: $isActive, seeIt: .constant(false))
                                    })
                                }
                                Spacer()
                            }.padding(50)
                        }
                    }
                })
            }
            .overlay(
                (scheme == .dark ? Color.black : Color.white)
                //Esta parte no sé como cambiarla para que funcione igual
                    .frame(height:UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.container, edges: .top)
                //Esto es para que ignore la parte de arriba de la pantalla.
                    .opacity(homeData.offset > 200 ? 1.0 : 0.0)
                , alignment: .top
            ).onAppear{
                avm.getAlbumList(){
                    result in
                    Albums = result
                } responseData: { resp in
                    if resp.status == 403 || resp.status == 401 || resp.status == 404 {
                        UserDefaults.standard.set(false,forKey: "login")
                        logueado = false
                        let tokenPush = Messaging.messaging().fcmToken ?? ""
                        //print("token Uni:", tokenPush)
                        let idUser = UserDefaults.standard.string(forKey: "id") ?? ""
                        deleteDevice(id_device: tokenPush, id_user: idUser)
                    }
                }
                album_update = UserDefaults.standard.string(forKey: "album_update") ?? ""
                items_update = UserDefaults.standard.integer(forKey: "items_up")
            }.padding(.bottom, 80)
            
            if editorP {
                HStack(alignment: .center) {
                    Button(action: {
                        showModalLoading()
                        uvm.updateUserInfo(name: nameUser, descrip: descrip, urlImg: editorB.imgPortadaP, responseData: { resp in
                            print(resp)
                            if resp.status == 200 {
                                editorP = false
                                UserDefaults.standard.set(editorB.imgPortadaP, forKey: "portada")
                                UserDefaults.standard.set(nameUser,forKey: "nombre")
                                UserDefaults.standard.set(descrip,forKey: "descrip")
                            } else {
                                alertRegister = true
                            }
                            self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                        })
                    }, label: {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .frame(width: 85, height: 35)
                            Text(lenguaje == "es" ? "Guardar" : "Save").font(.system(size: 12))
                        }
                    })
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .alert(isPresented: $alertRegister, content: {
                        Alert(title: Text("Mensaje"), message: Text("Ocurrio un problema"))
                    })
                    
                    if !loading {
                        Spacer()
                    }
                    Button(action: {
                        print(UserDefaults.standard.string(forKey: "nombre") ?? "")
                        editorP = false
                        nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
                        descrip = UserDefaults.standard.string(forKey: "descrip") ?? ""
                        
                        if nameUser.isEmpty {
                            nameUser = lenguaje == "es" ? "Tú nombre" : "Your name"
                        }
                        
                        if descrip.isEmpty {
                            descrip = lenguaje == "es" ? "¡Bienvenid@ a mi perfil de Stickjoy!" : "Welcome to my new Stickjoy profile"
                        }
                        
                        editorB.imgPortadaP = UserDefaults.standard.string(forKey: "portada") ?? ""
                    }, label: {
                        VStack {
                            Image(systemName: "x.circle.fill")
                                .frame(width: 85, height: 35)
                            Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                                .font(.system(size: 12))
                        }
                    })
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
                .background(scheme == .dark ? Color.black : .white)
            }
        }
        .toolbar(editorP ? .hidden : .visible, for: .tabBar)
        .onAppear{
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            descrip = UserDefaults.standard.string(forKey: "descrip") ?? ""
            
            if nameUser.isEmpty {
                nameUser = lenguaje == "es" ? "Tú nombre" : "Your name"
            }
            
            if descrip.isEmpty {
                descrip = lenguaje == "es" ? "¡Bienvenid@ a mi perfil de Stickjoy!" : "Welcome to my new Stickjoy profile"
            }
            
            avm.picktureList = []
            if let id = UserDefaults.standard.string(forKey: "id") {
                uvm.getUserDetails(user_id: id, imgP: { img in
                    editorB.imgPortadaP = img
                })
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .refreshable(action: {
            avm.getAlbumList(){ result in
                Albums = result
            } responseData: { resp in
                
            }
        })
    }
    
    func showModalLoading(){
        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
            ModalSpinnerView()
        }
    }
    
    func deleteDevice(id_device:String, id_user:String){
        uvm.deleteIdDevice(id_device: id_device, id_user: id_user)
    }
}

/*@available(iOS 16.0, *)
struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(logueado: .constant(false), lenguaje:.constant("es"), proceso: .constant(false))
    }
}*/

struct ModalSpinnerView: View {
    var body: some View {
        ZStack {
            //Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack {
                ProgressView() // Muestra un indicador de actividad (spinner)
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.modalTransitionStyle = transitionStyle
        toPresent.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.present(toPresent, animated: true, completion: nil)
    }
}
