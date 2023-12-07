//
//  MySelectionScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 27/11/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit
import Combine

struct ElementItem: Identifiable {
    var id = UUID()
    var name:String
    var description:String
    var tipo:Int
    var url:String
    var upload:Bool
    var success:Bool
    var uploading:Bool
    var alto:String
    var ancho:String
    var duracion:String
    var ratio:Double
}

struct AlbumSelectView: Identifiable {
    let id = UUID()
    var id_album:String
    var name:String
    var descrip:String
    var url:String
    var userName:String
}

struct MySelectionScreen: View {
    @StateObject var stm:StorageManager
    @Binding var shouldPopToRootView:Bool
    @Binding var isAlbumRoot:Bool
    @State var lenguaje = "es"
    @State var albumSelected:AlbumSelectView
    @State var showSelectPicker = false
    @Environment (\.colorScheme) var scheme
    @Environment (\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var proceso:Bool
    @Binding var porcentaje:Float
    @Binding var album_up : String
    @Binding var items_up:Int
    @State var change_alb = false
    @Binding var isUpload:Bool
    @State var isDetailV = false
    @State var suscriptor = false
    var body: some View {
            VStack {
                
                NavigationLink(destination: DetailSelectionScreen(stm: stm, shouldPopToRootView: $shouldPopToRootView, lenguaje: $lenguaje, isAlbumRoot: $isAlbumRoot, proceso: $proceso, albumSelected: albumSelected, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload:$isUpload , isDetailv: $isDetailV), isActive: $isDetailV) {
                    EmptyView()
                }
                
                Text(lenguaje == "es" ? "Los elementos seleccionados se subirán al siguiente álbum:" : "The selected elements will upload to the following album:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                AlbumSelected(/*stm: stm,*/ isAlbumRoot: $isAlbumRoot, shouldPopToRootView: $shouldPopToRootView, change_al: $change_alb, albumSelection: albumSelected)
                ScrollView {
                    ForEach(stm.listaImagenes, id: \.id) { item in
                            ElementSelecRow(/*stm: stm,*/ stm: stm, lenguaje: $lenguaje, item: item)
                            .onTapGesture {
                                isDetailV = true
                            }
                        //.environmentObject(stm)
                    }
                }
                
                Spacer()
                if stm.listaImagenes.count > 0 {
                    if isAlbumRoot {
                        Button(action: {
                            print(stm.listaImagenes.count)
                            UserDefaults.standard.set(true, forKey: "uploading")
                            UserDefaults.standard.set(stm.listaImagenes.count, forKey: "items_up")
                            items_up = stm.listaImagenes.count
                            proceso = true
                            album_up = albumSelected.id_album
                            DispatchQueue.global().async {
                                stm.updateTest(id_album: albumSelected.id_album, nameAlbum: albumSelected.name, upload: { up in
                                    print(up)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        if up {
                                            stm.listaImagenes = []
                                            UserDefaults.standard.set(false, forKey: "uploading")
                                            proceso = false
                                            porcentaje = 0.0
                                            //avm.getAlbumDetail(idAlbum: albumSelected.id_album)
                                        }
                                    }
                                }, porcent: { p in
                                    porcentaje = p
                                })
                            }
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text(lenguaje == "es" ? "Subir" : "Upload")
                                .padding()
                                .foregroundColor(scheme == .dark ? .white : .black)
                                .frame(maxWidth: 250)
                                .background(Color(hex: "#9dc3e6"))
                                .cornerRadius(18)
                                .padding(10)
                        })
                        .padding(.bottom, isAlbumRoot ? 20 : 0)
                    } else {
                        NavigationLink(destination: UploadingScreen(stm: stm, shouldPopToRootView: $shouldPopToRootView, proceso: $proceso, albumSelected: albumSelected, porcentaje: $porcentaje, album_up: $album_up, items_up: $items_up, isUpload: $isUpload, isDetailV: $isDetailV), label: {
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
                       showSelectPicker = true
                   }, label: {
                       HStack {
                           Image(systemName: "chevron.left")
                           Text(lenguaje == "es" ? "Biblioteca" : "Library")
                       }
                   })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isAlbumRoot {
                            presentationMode.wrappedValue.dismiss()
                            //shouldPopToRootView = false
                        } else {
                            // Regresar a la vista raíz
                            shouldPopToRootView = false
                            isUpload = false
                            //presentationMode.wrappedValue.dismiss()
                            print("desde crea")
                            albumSelected = AlbumSelectView(id_album: "", name: "", descrip: "", url: "", userName: "")
                        }
                        
                    }) {
                        Text(lenguaje == "es" ? "Cancelar" : "Cancel")
                    }
                }
            }
            .mediaImporter(isPresented: $showSelectPicker,
                           allowedMediaTypes: .all,
                           allowsMultipleSelection: suscriptor) { result in
                switch result {
                case .success(let urls):
                    if urls.count > 0 {
                        showSelectPicker = false
                        createObjectListElemenst(urls: urls, suscrip: suscriptor)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .onAppear {
                suscriptor = UserDefaults.standard.bool(forKey: "suscriptor")
                if stm.listaImagenes.count == 0 {
                    showSelectPicker = true
                }
                lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
            }
            .fullScreenCover(isPresented: $change_alb, content: {
                ChangeAlbumScreen(lenguaje: $lenguaje, albumSelection: $albumSelected, changeAlb: $change_alb)
            })
    }
    
    func createObjectListElemenst(urls:[URL], suscrip:Bool){
        for uri in urls {
            getTypeFile(url: uri, result: { res in
                if suscrip {
                    stm.listaImagenes.append(ElementItem(name: "", description: "", tipo: res.tipo, url: "\(uri)", upload: false, success: false, uploading: false, alto: "\(res.alto)", ancho: "\(res.ancho)", duracion: "\(res.tiempo)", ratio: res.ancho / res.alto))
                } else {
                    stm.listaImagenes = []
                    stm.listaImagenes.append(ElementItem(name: "", description: "", tipo: res.tipo, url: "\(uri)", upload: false, success: false, uploading: false, alto: "\(res.alto)", ancho: "\(res.ancho)", duracion: "\(res.tiempo)", ratio: res.ancho / res.alto))
                }
                
            })
        }
    }
    
    func getTypeFile(url:URL, result:@escaping (configVideo) -> Void) {
        switch try! url.resourceValues(forKeys: [.contentTypeKey]).contentType! {
        case let contentType where contentType.conforms(to: .image):
            result(configVideo(alto: 0, ancho: 0, tipo: 1, tiempo: "00:00"))
        case let contentType where contentType.conforms(to: .audiovisualContent):
            //result(2)
            let tiempo = self.getVideoDuration(from: url)
            let resol = self.initAspectRatioOfVideo(with: url)
            result(configVideo(alto: resol.alto, ancho: resol.ancho, tipo: 2, tiempo: tiempo))
        default:
            result(configVideo(alto: 0, ancho: 0, tipo: 1, tiempo: "00:00"))
        }
    }
    func initAspectRatioOfVideo(with fileURL: URL) -> configVideo {
      let resolution = resolutionForLocalVideo(url: fileURL)
      guard let width = resolution?.width, let height = resolution?.height else {
          return configVideo(alto: 0, ancho: 0, tipo: 1, tiempo: "0")
      }
        return configVideo(alto: height, ancho: width, tipo: 2, tiempo: "0")
    }
    func getVideoDuration(from path: URL) -> String {
        let asset = AVURLAsset(url: path)
        let duration: CMTime = asset.duration
        
        let totalSeconds = CMTimeGetSeconds(duration)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    private func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
       let size = track.naturalSize.applying(track.preferredTransform)
       return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

struct AlbumSelected : View {
    //@EnvironmentObject var stm : StorageManager
    @Binding var isAlbumRoot:Bool
    @Binding var shouldPopToRootView : Bool
    @Binding var change_al:Bool
    //@Binding var listElementsSelected:[ElementItem]
    var albumSelection:AlbumSelectView
    @State var lenguaje = "es"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack {
            WebImage(url: URL(string: albumSelection.url))
                    .resizable()
                    .placeholder(Image("stickjoyLogo"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            Text(albumSelection.name)
                .font(.headline)
            Spacer()
            if !isAlbumRoot {
                Button(lenguaje == "es" ? "Cambiar" : "Change") {
                  change_al = true
                }
            }
        }
        .padding()
        .onAppear {
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
}

struct ElementsSelected : View {
    @Binding var shouldPopToRootView : Bool
    @Binding var lenguaje:String
    var items:[ElementItem]
    //@State var showAlert = false
    //@State var uuid = UUID()
    var body: some View {
        ScrollView {
            /*ForEach(items, id: \.id) { item in
                NavigationLink(destination: DetailSelectionScreen(/*stm: stm,*/ shouldPopToRootView: $shouldPopToRootView), label: {
                    ElementSelecRow(/*stm: stm,*/ lenguaje: $lenguaje, item: item)
                })
            }*/
        }
    }
}

struct configVideo{
    var alto:Double
    var ancho:Double
    var tipo:Int
    var tiempo:String
}

struct ElementSelecRow : View {
    @StateObject var stm:StorageManager
    @Binding var lenguaje:String
    @State var showAlert = false
    //@Binding var listElements:[ElementItem]
    @State var thumbnailImage = UIImage(named: "stickjoyLogoBlue")
    
    var item:ElementItem
    var body: some View {
        HStack {
            if item.tipo == 1 {
                WebImage(url: URL(string: item.url))
                        .resizable()
                        .placeholder(Image("stickjoyLogoBlue"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
            } else {
                ZStack(alignment:.bottomTrailing) {
                    
                    Image(uiImage: (thumbnailImage ?? UIImage(named: "stickjoyLogoBlue"))!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    
                    Text(item.duracion)
                        .padding(4)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .padding(2)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if item.name.isEmpty {
                    Text(lenguaje == "es" ? "Nombre" : "Name")
                        .font(.title2)
                } else {
                    Text(item.name)
                        .font(.title2)
                }
                if item.description.isEmpty {
                    Text(lenguaje == "es" ? "Descripción" : "Description")
                        .font(.body)
                        .foregroundColor(.gray)
                }else {
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: {
                showAlert = true
            }, label: {
                Text(lenguaje == "es" ? "Quitar" : "Delete")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(lenguaje == "es" ? "Mensaje" : "Messagge"),
                      message: Text(lenguaje == "es" ? "¿Quieres eliminar este elemento?" : "Are you sure you want to delete it?"),
                      primaryButton: .default(Text(lenguaje == "es" ? "Aceptar" : "Accept"), action: {
                    // Acción cuando se presiona Aceptar
                    if let indexEl = stm.listaImagenes.firstIndex(where: {$0.id == item.id}) {
                        stm.listaImagenes.remove(at: indexEl)
                    }
                }),
                secondaryButton: .cancel(Text(lenguaje == "es" ? "Cancelar" : "Cancel")))
            }
        }
        .padding(.horizontal)
    }
    
    func generateThumbnail(videoURL:URL) {
        //if let urlV = URL(string:item.url) {
        stm.loadImage(url: videoURL, image: { img in
            thumbnailImage = img
        })
        //}
    }
}
