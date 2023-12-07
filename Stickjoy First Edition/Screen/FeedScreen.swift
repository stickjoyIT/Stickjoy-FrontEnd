//
//  FeedScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 12. Pantalla de Feed
//  Paulo:
//  ¿Qué falta?: Conectar botón de Instagram, de ir al álbum, falta variante nuevo poner una condición. 

import SwiftUI
import GoogleMobileAds
import FirebaseMessaging
import Firebase

struct FeedScreen: View {
    @State private var feedHeaderHeight: CGFloat = 0
    @ObservedObject var uvm = UsuariosViewModel()
    @Binding var lenguaje:String
    @Binding var logueado:Bool
    @State var feedList = [itemFeed]()
    
    @State var albumView = false
    @State var avm = AlbumViewModel()
    @State var id_album = ""
    @State var name_album = ""
    @State var descrip_album = ""
    @State var imgPortada = ""
    @State var username = ""
    @State var id_usuario = ""
    
    @State var tieneFeed = false
    
    var body: some View {
        VStack {
            if !tieneFeed {
                EmptyFeedScreen(lenguaje: $lenguaje)
            } else {
                    VStack() {
                        FeedHeader(lenguaje: $lenguaje).frame(height:80)
                        ScrollView {
                            VStack(spacing: 16) {
                                // Add the horizontal grid of AnchoredProfileView
                                LazyVStack(spacing: 20) {
                                    ForEach(Array($uvm.feedList.enumerated()), id: \.offset) { index, feeditem in
                                        //Aquí tiene que ir diferente para que traiga la información del file FeedItem
                                        if index % 5 == 0 {
                                            if index > 1 {
                                                VStack {
                                                    Text("Anuncio")
                                                    BannerViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716").padding(.bottom, 300)
                                                        .padding(.horizontal, 40)
                                                }
                                            }
                                        }
                                        FeedItem(albumView: $albumView, itemFeed: feeditem, lenguaje: $lenguaje, id_album: $id_album, name_album: $name_album, descrip_album: $descrip_album, imgPortada: $imgPortada, username: $username, id_usuario: $id_usuario)
                                    }
                                }
                                .padding(.top, 5)
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $albumView, content: {
                        ElsesAlbumScreen(avm:avm ,id_album: $id_album, nameAlbum: $name_album, descripAlbum: $descrip_album, username: $username, imgPortada: $imgPortada, id_user: $id_usuario, pickturesList: $avm.picktureList, iColaborator: .constant(false), proceso: .constant(false), album_up:.constant(""), porcentaje: .constant(0.0), items_up:.constant(0), isCollaborator: $albumView)
                    })
            }
        }.onAppear {
            uvm.getFeedUser(feeds: {feeds in
                if feeds.status == 401 || feeds.status == 403 || feeds.status == 404 {
                    UserDefaults.standard.set(false,forKey: "login")
                    logueado = false
                    let tokenPush = Messaging.messaging().fcmToken ?? ""
                    //print("token Uni:", tokenPush)
                    let idUser = UserDefaults.standard.string(forKey: "id") ?? ""
                    deleteDevice(id_device: tokenPush, id_user: idUser)
                }
            })
            tieneFeed = UserDefaults.standard.bool(forKey: "isFeed")
            print("tiene feed", tieneFeed)
        }.refreshable(action: {
            uvm.getFeedUser(feeds: {feeds in })
            tieneFeed = UserDefaults.standard.bool(forKey: "isFeed")
        })
    }
    
    func deleteDevice(id_device:String, id_user:String){
        uvm.deleteIdDevice(id_device: id_device, id_user: id_user)
    }
}

struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen(lenguaje: .constant("es"), logueado: .constant(false))
    }
}

struct BannerViewController: UIViewControllerRepresentable {
    var adUnitID: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 300))
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: adSize)
        
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = viewController
        
        let request = GADRequest()
        bannerView.load(request)
        
        viewController.view.addSubview(bannerView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No se necesita implementación aquí
    }
}

struct BannerAlbumViewController: UIViewControllerRepresentable {
    var adUnitID: String
    var ancho:Double
    var alto:Double
    func makeUIViewController(context: Context) -> some UIViewController {
        let adSize = GADAdSizeFromCGSize(CGSize(width: ancho, height: alto))
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: adSize)
        
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = viewController
        
        let request = GADRequest()
        bannerView.load(request)
        
        viewController.view.addSubview(bannerView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No se necesita implementación aquí
    }
}

struct BannerFotoViewController: UIViewControllerRepresentable {
    var adUnitID: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let adSize = GADAdSizeFromCGSize(CGSize(width: 50, height: 50))
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: adSize)
        
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = viewController
        
        let request = GADRequest()
        bannerView.load(request)
        
        viewController.view.addSubview(bannerView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No se necesita implementación aquí
    }
}


struct SkeletonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 200, height: 16)
                    .opacity(0.3)
                    .offset(x: -100)
                    .rotationEffect(.degrees(70), anchor: .center)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 200, height: 16)
                    .opacity(0.3)
                    .offset(x: -60)
                    .rotationEffect(.degrees(70), anchor: .center)
            )
    }
}


