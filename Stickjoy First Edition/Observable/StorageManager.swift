//
//  StorageManager.swift
//  Stickjoy First Edition
//
//  Created by admin on 25/08/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import Alamofire
import Combine
import AVKit

struct ResponseFirebase {
    var success:Bool
    var url:String
    var index:Int
}

class StorageManager: ObservableObject {
    let storage = Storage.storage()
    
    @Published var porcent = 0
    @Published var listAlbum = [AlbumInfo]()
    @Published var listaImagenes = [ElementItem]()
    @Published var loading = false
    
    @Published var lenguaje = "es"
    @Published var showAlert = false
    @Published var selectItemId = UUID()
    
    @Published var badge = 0
    
    func uploadMultipleFile(id_album:String, nameAlbum:String, compation:@escaping (String) -> Void){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        for (index, it) in self.listaImagenes.enumerated() {
            self.listaImagenes[index].uploading = true
            if let urlC = URL(string:it.url ) {
                DispatchQueue.main.async {
                    self.uploadFile(id: id, urls: urlC, index: index, responseData: { resp in
                        if resp.success {
                            let mediaUpLoad = self.listaImagenes[resp.index]
                            self.addMedia(urlImg: resp.url, id_album: id_album, name: mediaUpLoad.name, descrip: mediaUpLoad.description, type: mediaUpLoad.tipo, duration: mediaUpLoad.duracion, height: mediaUpLoad.alto, weight: mediaUpLoad.ancho, responseSuccess: { respAddMedia in
                                if respAddMedia.status == 200 {
                                    self.listaImagenes[resp.index].success = true
                                } else {
                                    self.listaImagenes[resp.index].success = false
                                }
                                self.listaImagenes[resp.index].upload = true
                                self.listaImagenes[resp.index].uploading = false
                                compation("success")
                            })
                        } else {
                            self.listaImagenes[resp.index].success = resp.success
                            self.listaImagenes[resp.index].upload = true
                            self.listaImagenes[resp.index].uploading = false
                        }
                        compation("success")
                    })
                }
            }
            compation("success")
        }
    }
    
    func uploadFile(id:String, urls:URL, index:Int, responseData:@escaping (ResponseFirebase) -> Void){
        let storageRef = storage.reference()
        let nameFile = id+"/"+urls.lastPathComponent
        storageRef.child(nameFile).putFile(from:urls, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
                self.loading = false
            }
            if let metadata = metadata { print("Metadata: ", metadata) }
            storageRef.child(nameFile).downloadURL { url, error in
                if let error = error {
                    responseData(ResponseFirebase(success: false, url: "", index: index))
                    print("Error getting download URL: \(error)")
                    return
                }
                if let downloadURL = url {
                    //print("Download URL: \(downloadURL)")
                    responseData(ResponseFirebase(success: true, url: "\(downloadURL)", index: index))
                }
            }
            
        }
    }
    
    
    func addMedia(urlImg:String, id_album:String, name:String, descrip:String, type:Int, duration:String, height:String, weight:String ,responseSuccess:@escaping (ResponseData) -> Void){
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums/\(id_album)/media"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "name":name,
            "description":descrip,
            "url":urlImg,
            "type":type,
            "duration":duration,
            "height":"\(height)",
            "weight":"\(weight)"
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("parametros media", parameters)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("agregar media",json)
                    let status = json["status"] as? Int ?? 500
                    if status == 200 {
                        responseSuccess(ResponseData(status: status, message: "El registro fue un exito"))
                    } else {
                        responseSuccess(ResponseData(status: status, message: "Ocurrio un error"))
                    }
                }
            case .failure(let error):
                responseSuccess(ResponseData(status: 500, message: "Ocurrio un error"))
                print("error media",error)
            }
        }
        
    }
    
    func upload(urls: [URL], nameAlbum:String, compation:@escaping (String) -> Void) {
        
        loading = true
        
        // Create a storage reference
        let cleanName = nameAlbum.replacingOccurrences(of: " ", with: "_")
        let storageRef = storage.reference()
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let nameFile = id+"/"+urls.first!.lastPathComponent
        
        print(nameFile)
        
        let tasck = storageRef.child(nameFile).putFile(from:urls.first!, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
                compation("")
                self.loading = false
            }
            
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
            
            // Obtén la URL de descarga de la imagen
            storageRef.child(nameFile).downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    compation("")
                    self.loading = false
                    return
                }
                
                if let downloadURL = url {
                    print("Download URL: \(downloadURL)")
                    compation("\(downloadURL)")
                }
                
                self.loading = false
            }
            
        }
        tasck.observe(.progress) { snap in
            print("progreso: ", snap.progress!)
        }
    }
    
    
    func listAllFiles() {
        // Create a reference
        let storageRef = storage.reference().child("images")
        
        // List all items in the images folder
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error while listing all files: ", error)
            }
            
            for item in result!.items {
                print("Item in images folder: ", item)
            }
        }
    }
    
    func updateTest(id_album:String, nameAlbum:String,upload:@escaping (Bool) -> Void, porcent:@escaping (Float) -> Void){
        UserDefaults.standard.set(true, forKey: "uploading")
        UserDefaults.standard.set(false, forKey: "ClosePopup")
        UserDefaults.standard.set(id_album, forKey: "album_update")
        scheduleNotification(cantidad: self.listaImagenes.count)
        self.uploadMultipleFile(id_album: id_album, nameAlbum: nameAlbum, compation: { resp in
            self.checkAllUpload(lista: self.listaImagenes, upload: { up in
                upload(up)
            }, porcentN: { p in
                porcent(p)
            })
        })
        
       /*DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.badge = 1
            print("check segundo plano")
            for (index, it) in self.listaImagenes.enumerated() {
                self.listaImagenes[index].uploading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.listaImagenes[index].upload = true
                    self.listaImagenes[index].success = true
                    self.listaImagenes[index].uploading = false
                    self.checkAllUpload(lista: self.listaImagenes, upload: { up in
                        upload(up)
                    }, porcentN: { p in
                        porcent(p)
                    })
                }
            }
        }*/
    }
    
    func checkAllUpload(lista:[ElementItem], upload:@escaping (Bool) -> Void, porcentN:@escaping (Float) -> Void) {
        var countUpload = 0
        //var porcentaje = 0
        for item in lista {
            if item.upload {
                countUpload += 1
            }
        }
        
        print("Porcentaje: ", "\(Float(countUpload) / Float(lista.count))")
        print("upload: ",countUpload)
        print("lista: ",lista.count)
        
        porcentN((Float(countUpload) / Float(lista.count)) * 100)
        
        if countUpload == lista.count {
            upload(true)
        } else {
            upload(false)
        }
    }
    
    func getAlbumList(compation:@escaping ([AlbumInfo]) -> Void, responseData: @escaping (ResponseData) -> Void){
        listAlbum = []
        let myid = UserDefaults.standard.string(forKey: "id") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(myid)/albums"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("desde storage")
        Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    guard let status = json["status"] as? Int else { return }
                    if status == 200 {
                        guard let data = json["data"] as? NSArray else { return}
                        //print(data)
                        for item in data{
                            if let i = item as? NSDictionary {
                                //print("album: ", i)
                                let name = i["name"] as? String ?? ""
                                let descrip = i["description"] as? String ?? ""
                                let id = i["id"] as? String ?? ""
                                let url = i["url"] as? String ?? ""
                                let share_to = i["share_to"] as! NSArray
                                let privacy = i["privacy"] as! Int
                                let created_date = i["created_date"] as! NSDictionary
                                let last_added_date = i["last_added_date"] as! String
                                let owner = i["owner"] as! NSDictionary
                                let nameAdmin = owner["username"] as? String ?? ""
                                let owner_id = owner["user_id"] as! String
                                let creacion = created_date["_seconds"] as! Int
                                
                                let dateformarGN = DateFormatter()
                                dateformarGN.locale = Locale(identifier: "es_MX")
                                dateformarGN.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                dateformarGN.timeZone = TimeZone(identifier: "UTC")
                                var relativeDate = ""
                                var localDateC = ""
                                let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                                if let actualizacion = dateformarGN.date(from: last_added_date) {
                                    let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                                    let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion.timeIntervalSince1970))
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "es_MX")
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    dateFormatter.timeZone = .current
                                    localDateC = dateFormatter.string(from: dateC)
                                    //let localDateU = dateFormatter.string(from: dateU)
                                    
                                    let timeInterval = NSDate().timeIntervalSince1970
                                    
                                    let interval = TimeInterval(actualizacion.timeIntervalSince1970) - timeInterval
                                    
                                    let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                                    let formatter = RelativeDateTimeFormatter()
                                    if lenguaje == "es" {
                                     formatter.locale = Locale(identifier: "es")
                                    } else {
                                        formatter.locale = Locale(identifier: "en")
                                    }
                                    formatter.unitsStyle = .abbreviated
                                    relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                                }
                                var tipoAlbum = "Personal"
                                
                                if share_to.count > 0 {
                                    tipoAlbum = lenguaje == "es" ? "Colaborativo" : "Collaborative"
                                }
                                var iColaborator = false
                                if share_to.contains(myid) {
                                    iColaborator = true
                                }
                                //print("soy colaborador: ",iColaborator)
                                let creado = lenguaje == "es" ? "Creado el" : "Created on"
                                let actualizado = lenguaje == "es" ? "Actualizado" : "Updated"
                                let esAdmin = lenguaje == "es" ? "es" : "is"
                                let partici = lenguaje == "es" ? "Participantes" : "Participants"
                                self.listAlbum.append(AlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "\(nameAdmin.replacingOccurrences(of: " ", with: "")) \(esAdmin) admin", albumCreation: "\(creado) \(localDateC)", albumUpdate: "\(actualizado) \(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) \(partici)", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip, userOwner: nameAdmin, isCollap:iColaborator))
                            }
                        }
                        compation(self.listAlbum)
                        responseData(ResponseData(status: status, message: ""))
                    } else {
                        compation([])
                        responseData(ResponseData(status: status, message: ""))
                    }
                } else {
                    compation([])
                    responseData(ResponseData(status: 500, message: ""))
                }
            case .failure(let error):
                print("error albums",error)
                compation([])
                responseData(ResponseData(status: 500, message: ""))
            }
        }
    }
    
    func scheduleNotification(cantidad:Int) {
        // Crear contenido de la notificación
        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        let content = UNMutableNotificationContent()
        content.title = lenguaje == "es" ? "Proceso" : "Process"
        content.body = "\(lenguaje == "es" ? "Subiendo" : "Uploading") \(cantidad) \(lenguaje == "es" ? "elementos" : "elements")"
        content.sound = UNNotificationSound.default
        
        // Configurar el trigger para la notificación (en 5 segundos)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Crear el request de la notificación
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Solicitar autorización para mostrar notificaciones
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                // Agregar la notificación al centro de notificaciones
                UNUserNotificationCenter.current().add(request)
            } else if let error = error {
                print("Error al solicitar autorización para mostrar notificaciones: \(error)")
            }
        }
    }
    
    func getVideoThumbnail(url: URL) -> UIImage? {
            //let url = url as URL
            let request = URLRequest(url: url)
            let cache = URLCache.shared
            
            if let cachedResponse = cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
                return image
            }
            
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.maximumSize = CGSize(width: 250, height: 120)
            
            var time = asset.duration
            time.value = min(time.value, 2)
            
            var image: UIImage?
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                image = UIImage(cgImage: cgImage)
            } catch { }
            
            if let image = image, let data = image.pngData(), let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)
            }
            
            return image
        }
    
    func loadImage(url: URL, image:@escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                image(((UIImage(data: data) ?? UIImage(named: "placeholder"))!))
            }
        }.resume()
    }
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
