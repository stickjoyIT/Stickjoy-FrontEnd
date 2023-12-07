//
//  UploadPictureOrVideoScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre de Lista de Requerimientos: 10. Pop Up Menu - Subir Foto/Vídeo
//  Paulo: este pop up se hizo pantalla por cuestiones de navegación.
//  Falta añadir acciones a los botones (vienen en cada botón) y poner límite a los textfields. Además, que la foto que se muestra es la que el usuario eligió en el ImagePicker de IOS.
//  Opcional: si se puede hacer que el textfield de descripción sea de másd de 1 linea como en figma, estaría genial. Si no, dejar así y corregir en 2da versión.

import SwiftUI
import AVKit
import Combine

struct UploadPictureOrVideoScreen: View {
    @ObservedObject var avm:AlbumViewModel
    @Environment (\.colorScheme) var scheme
    var storageManager = StorageManager()
    @State private var elementName = ""
    @State private var elementDescription = ""
    @State var lenguaje = ""
    @Binding var urlImgOrVideo:String
    @State var tipo = 1
    @State var duration = ""
    @State var play = false
    @Binding var id_album:String
    @Binding var name_album:String
    @State var alert = false
    @State var mensaje = ""
    @State var model = AVPlayer()
    @State var loading = false
    @State var resolution = 0.0
    @State var alto = 0.0
    @State var ancho = 0.0
    let maxName = 20
    let maxDescrip = 250
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Añadir acción de regresar
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title)
                    }
                    Spacer()
                    Text(lenguaje == "es" ? "Subir foto o video" : "Upload Picture or Video")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    Spacer()
                }
                .padding()
                //Aquí debe de ir la foto que se seleccionó en el ImagePicker de IOS.
                VStack(alignment:.center) {
                    if tipo == 1 {
                        AsyncImage(url: URL(string:urlImgOrVideo), content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Ajusta el color, el radio y la posición de la sombra
                                .cornerRadius(4)
                                .padding()
                        }, placeholder: {
                            Image("uploadedPicture")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Ajusta el color, el radio y la posición de la sombra
                                .cornerRadius(4)
                                .padding()
                        })
                    } else {
                        VideoPlayer(player: model)
                            //.scaledToFill()
                            .aspectRatio(ancho / alto,contentMode: .fill)
                            //.frame(width: ancho / 3)
                            //.frame(height: alto / 3)
                            .cornerRadius(4)
                            .onAppear{
                                model.volume = 0
                                model.play()
                            }
                            .padding(4)
                    }
                }
                
                //Nombre de elemento, falta poner descripción de 22 caractéres
                TextField(lenguaje == "es" ? "Nombre" : "Name", text: $elementName)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .onReceive(Just(elementName)) { _ in limitText(maxName) }
                
                //Parrafo para descripción, falta poner límite de 250 caractéres.
                TextField(lenguaje == "es" ? "Descripcion" : "Description", text: $elementDescription, axis: .vertical)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .onReceive(Just(elementDescription)) { _ in limitText(maxDescrip) }
                    .lineLimit(2...5)
                    .onChange(of: elementDescription) { newValue in
                        if newValue.count > maxDescrip {
                            elementDescription = String(newValue.prefix(maxDescrip))
                        }
                    }
                
                if loading {
                    ProgressView()
                } else {
                    Button(action: {
                        // Añadir acción de subir al álbum y llevarte a esa pantalla de álbum para verlo.
                        loading = true
                        var urls = [URL]()
                        urls.append(URL(string: urlImgOrVideo)!)
                        storageManager.upload(urls: urls, nameAlbum: name_album){ success in
                            if !success.isEmpty {
                                avm.addMedia(urlImg: success, id_album: id_album,name: elementName, descrip: elementDescription, type: tipo, duration: duration, height: alto, weight: ancho, responseSuccess: { success in
                                    alert = true
                                    if success.status == 200 {
                                        mensaje = success.message
                                        dismiss()
                                    } else {
                                        mensaje = success.message
                                    }
                                    loading = false
                                })
                            }
                        }
                    }) {
                        Text(lenguaje == "es" ? "Subir a mi álbum" :"Upload to my album")
                            .foregroundColor(Color.white)
                            .frame(width: 250)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(32)
                    }
                    .alert(isPresented: $alert, content: {
                        Alert(title: Text("Mensaje"), message: Text(mensaje))
                    })
                }
                Spacer()
            }.onAppear{
                lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                if let urlType = URL(string: urlImgOrVideo) {
                    getTypeFile(url: urlType)
                }
            }
            .background(scheme == .dark ? .black : .white)
            .padding()
        }
    }
    
    //Function to keep text length in limits
        func limitText(_ upper: Int) {
            if elementName.count > upper {
                elementName = String(elementName.prefix(upper))
            }
        }
    //Function to keep text length in limits
        func limitTextDesc(_ upper: Int) {
            if elementDescription.count > upper {
                elementDescription = String(elementDescription.prefix(upper))
            }
        }
    
    func getTypeFile(url:URL) {
        switch try! url.resourceValues(forKeys: [.contentTypeKey]).contentType! {
        case let contentType where contentType.conforms(to: .image):
            tipo = 1
        case let contentType where contentType.conforms(to: .audiovisualContent):
            duration = self.getVideoDuration(from: url)
            resolution = self.initAspectRatioOfVideo(with: url)
            tipo = 2
            model = AVPlayer(url: URL(string:urlImgOrVideo)!)
        default:
            tipo = 1
        }
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
    func initAspectRatioOfVideo(with fileURL: URL) -> Double {
      let resolution = resolutionForLocalVideo(url: fileURL)
      guard let width = resolution?.width, let height = resolution?.height else {
         return 0
      }
        alto = height
        ancho = width
        
        print(alto)
        print(ancho)
      return Double(height / width)
    }
    
    private func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
       let size = track.naturalSize.applying(track.preferredTransform)
       return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

struct UploadPictureOrVideoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UploadPictureOrVideoScreen(avm: AlbumViewModel(), urlImgOrVideo: .constant(""), id_album: .constant(""), name_album: .constant(""))
    }
}
