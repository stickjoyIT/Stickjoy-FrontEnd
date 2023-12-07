//
//  Uploading.swift
//  Stickjoy First Edition
//
//  Created by admin on 28/11/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct UploadingScreen: View {
    @StateObject var stm:StorageManager
    @ObservedObject var avm = AlbumViewModel()
    @State var lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
    @Binding var shouldPopToRootView : Bool
    @Binding var proceso:Bool
    var albumSelected:AlbumSelectView
    @State var isComplete = false
    @Binding var porcentaje:Float
    @Binding var album_up:String
    @Binding var items_up:Int
    @Binding var isUpload:Bool
    @Binding var isDetailV:Bool
    @State var suscriptor = false
    var body: some View {
        VStack {
            Text(lenguaje == "es" ? "Los elementos seleccionados se subirán al siguiente álbum:" : "The selected elements will upload to the following album:")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
            
            AlbumSelectedUp(shouldPopToRootView: $shouldPopToRootView, albumSelection: albumSelected)
            ElementsSelectedUp(/*stm: stm,*/ items: stm.listaImagenes, shouldPopToRootView: $shouldPopToRootView, lenguaje: $lenguaje)
            
            Spacer()
            
            NavigationLink(destination: ListoScreen(shouldPopToRootView: $shouldPopToRootView, album_up: $album_up, porcentaje: $porcentaje, albumSelection: albumSelected, isUpload: $isUpload, isDetailV: $isDetailV, isComplete: $isComplete), isActive: $isComplete) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(lenguaje == "es" ? "Subiendo" : "Uploading")
                    .font(.largeTitle)
                    .bold()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
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
                .padding(8)
            }
        }
        .onAppear {
            suscriptor = UserDefaults.standard.bool(forKey: "suscriptor")
            porcentaje = 0
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            if stm.listaImagenes.count > 0 {
                let uploadingProccess = UserDefaults.standard.bool(forKey: "uploading")
                if uploadingProccess {
                    print("Subiendo o ya subio")
                } else {
                    proceso = true
                    print("Subiendo aparece: \(stm.listaImagenes)")
                    UserDefaults.standard.set(stm.listaImagenes.count, forKey: "items_up")
                    items_up = stm.listaImagenes.count
                    DispatchQueue.global().async {
                        stm.updateTest(id_album: albumSelected.id_album, nameAlbum: albumSelected.name, upload: { up in
                            print(up)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isComplete = up
                                if up {
                                    stm.listaImagenes = []
                                    UserDefaults.standard.set(false, forKey: "uploading")
                                    proceso = false
                                    avm.getAlbumDetail(idAlbum: albumSelected.id_album)
                                    porcentaje = 0.0
                                }
                            }
                        }, porcent: { p in
                            porcentaje = p
                        })
                    }
                }
            }
        }
    }
}

struct AlbumSelectedUp : View {
    @Binding var shouldPopToRootView : Bool
    var albumSelection:AlbumSelectView
    var body: some View {
        HStack {
            WebImage(url: URL(string: albumSelection.url))
                    .resizable()
                    .placeholder(Image("stickjoyLogo"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
            Text(albumSelection.name)
                .font(.headline)
            Spacer()
            Image(systemName: "lock.circle.fill")
                .font(.title)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct ElementsSelectedUp : View {
    var items:[ElementItem]
    @Binding var shouldPopToRootView : Bool
    @Binding var lenguaje:String
    var body: some View {
        ScrollView {
            ForEach(items, id: \.id) { item in
                ElementSelecRowUp(lenguaje: $lenguaje, listElements: items, item: item)
            }
        }
    }
}

struct ElementSelecRowUp : View {
    @Binding var lenguaje:String
    @State var showAlert = false
    var listElements:[ElementItem]
    var item:ElementItem
    var body: some View {
        HStack {
            WebImage(url: URL(string: item.url))
                    .resizable()
                    .placeholder(Image("stickjoyLogoBlue"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
            VStack(alignment: .leading) {
                if item.name.isEmpty {
                    Text(lenguaje == "es" ? "Nombre" : "Name")
                        .font(.subheadline)
                } else {
                    Text(item.name)
                        .font(.subheadline)
                }
                if item.description.isEmpty {
                    Text(lenguaje == "es" ? "Descripción" : "Description")
                        .font(.caption)
                        .foregroundColor(.gray)
                }else {
                    Text(item.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            if item.uploading {
                LottieView(animation: .named("loading_2"))
                    .looping()
                    .aspectRatio(4, contentMode: .fill)
                    .frame(maxWidth: 30, maxHeight: 60)
            } else {
                if item.upload && item.success {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                } else {
                    if !item.success {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    } else {
                        Text("En cola..")
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
