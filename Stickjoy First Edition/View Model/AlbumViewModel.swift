//
//  AlbunViewModel.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import AVKit

struct pickture : Identifiable {
    let id = UUID()
    var album_id:String
    var id_img:String
    var order:Int
    var url:URL
    var user_id:String
    var user:String
    var user_name:String
    var image:UIImage
    var tipo:Int
    var user_url:String
    var duration:String
    var description:String
    var namePickture:String
    var alto:Double
    var ancho:Double
    var ratio:Double
}

struct orderPick {
    var id:String
    var order:Int
}

struct colaborador:Identifiable {
    let id = UUID()
    var user_id:String
    var name:String
    var url:String
    var username:String
}
struct ImageUrl: Identifiable {
    let id = UUID()
    var url:URL
    var tipo:Int
}

final class AlbumViewModel : ObservableObject {
    @Published var currentPage:pickture?
    @Published var matrizPick = [[pickture]]()
    @Published var listAlbum = [AlbumInfo]()
    @Published var mensaje = ""
    @Published var modoEditor = false
    @Published var loading = false
    @Published var urlImagesAlbum = [pickture]()
    @Published var albumsFriend = [ElsesAlbumInfo]()
    @Published var picktureList:[pickture] = [pickture]()
    @Published var picktureListMatrix:[pickture] = [pickture]()
    @Published var arrayConst:[pickture] = [pickture]()
    @Published var arrayConstMatrix:[pickture] = [pickture]()
    @Published var arrayNewOrder = [orderPick]()
    @Published var colaboradores = [colaborador]()
    var imagenesNewOrder = [AnyObject]()
    
    func getAlbumList(compation:@escaping ([AlbumInfo]) -> Void, responseData: @escaping (ResponseData) -> Void){
        listAlbum = []
        let myid = UserDefaults.standard.string(forKey: "id") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IkFKVnVZbU9rMEFVQ05OdU1ZOWxlIiwiZW1haWwiOiJ0ZXN0aWduYWNpb0BnbWFpbC5jb20iLCJpYXQiOjE2OTI4MjQwNDUsImV4cCI6MTY5MzQyODg0NX0.n1m6P8m2--u9UC7YwsIpWKzPItR-Du9qzlvEDRDzT7g"
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(myid)/albums"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        //print("url albums: ",url)
        //print("token user:", token)
        Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("json albums", json)
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
    
    func convertirFechaLocal(){
        // Crea un DateFormatter para formatear la fecha y hora global (UTC)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Ajusta el formato según tu necesidad
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        // Define una fecha y hora global (UTC)
        let globalDateStr = "2023-10-06 12:00:00"
        if let globalDate = dateFormatter.date(from: globalDateStr) {
            // Crea un DateFormatter para formatear la fecha y hora local
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Ajusta el formato según tu necesidad
            localDateFormatter.timeZone = TimeZone.current // Usa la zona horaria local del dispositivo

            // Convierte la fecha global (UTC) a la hora local
            let localDateStr = localDateFormatter.string(from: globalDate)
            print("Fecha y hora local:", localDateStr)
        } else {
            print("No se pudo convertir la fecha global.")
        }
    }
    
    func setModoEditor(modo:Bool){
        modoEditor = modo
    }
    
    func getAlbumViewInfo(id_album:String, id_user:String, albumInfo:@escaping (AlbumInfo) -> Void, isColaborator:@escaping (Bool) -> Void){
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id_user)/albums/\(id_album)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let myId = UserDefaults.standard.string(forKey: "id") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let i = json["data"] as? NSDictionary else {
                            return
                        }
                        print("info:",i)
                        let owner_id = i["owner_id"] as? String ?? ""
                        let name = i["name"] as? String ?? ""
                        let descrip = i["description"] as? String ?? ""
                        let id = i["id"] as? String ?? ""
                        let url = i["url"] as? String ?? ""
                        let share_to = i["share_to"] as! NSArray
                        let privacy = i["privacy"] as! Int
                        let created_date = i["created_date"] as! NSDictionary
                        let last_added_date = i["last_added_date"] as! NSDictionary
                        let owner = i["owner"] as! NSDictionary
                        let nameAdmin = owner["username"] as? String ?? ""
                        
                        let creacion = created_date["_seconds"] as! Int
                        let actualizacion = last_added_date["_seconds"] as! Int
                        
                        let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                        ///let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion))
                        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                        let dateFormatter = DateFormatter()
                        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        dateFormatter.timeZone = .current
                        if lenguaje == "es" {
                            dateFormatter.locale = Locale(identifier: "es")
                        } else {
                            dateFormatter.locale = Locale(identifier: "en")
                        }
                        let localDateC = dateFormatter.string(from: dateC)
                        ///let localDateU = dateFormatter.string(from: dateU)
                        
                        var tipoAlbum = "Personal"
                        
                        if share_to.count > 0 {
                            tipoAlbum = lenguaje == "es" ? "Colaborativo" : "Collaborative"
                        }
                        
                        let timeInterval = NSDate().timeIntervalSince1970
                        
                        let interval = TimeInterval(actualizacion) - timeInterval
                        
                        let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                        let formatter = RelativeDateTimeFormatter()
                        if lenguaje == "es" {
                            formatter.locale = Locale(identifier: "es")
                        } else {
                            formatter.locale = Locale(identifier: "en")
                        }
                        formatter.unitsStyle = .abbreviated
                        let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                        
                        ///let nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
                        isColaborator(false)
                        for colab in share_to {
                            if let i = colab as? String {
                                if i == myId {
                                    isColaborator(true)
                                }
                            }
                        }
                        let partici = lenguaje == "es" ? "Participantes" : "Participants"
                        albumInfo(AlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "\(nameAdmin)", albumCreation: "\(localDateC)", albumUpdate: "\(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) \(partici)", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip, userOwner: nameAdmin, isCollap: false))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createAlbum(nombre:String, descripcion:String, urlImg:String, descrip:String, compation:@escaping (Bool) -> Void, result:@escaping (String) -> Void){
        loading = true
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "name": nombre,
            "description": descrip,
            "url":urlImg,
            "privacy":0
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("parametros del album",parameters)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else {return}
                        let id_album = data["id"] as? String ?? ""
                        compation(true)
                        result(id_album)
                    } else {
                        compation(false)
                        result("")
                    }
                    self.loading = false
                }
            case .failure(let error):
                print("err", error)
                compation(false)
                result("")
                self.loading = false
            }
            
        }
        
    }
    
    func updateAlbum(album_id:String, nombre:String, descripcion:String, urlImg:String, descrip:String, privacy:Int, compation:@escaping (Bool) -> Void, result:@escaping (String) -> Void){
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "album_id":album_id,
            "name": nombre,
            "description": descrip,
            "url":urlImg,
            "privacy":privacy
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("parametros del album",parameters)
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    //print(json)
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else {return}
                        let id_album = data["id"] as? String ?? ""
                        compation(true)
                        result(id_album)
                    } else {
                        compation(false)
                        result("")
                    }
                }
            case .failure(let error):
                print("err", error)
                compation(false)
                result("")
            }
            
        }
        
    }
    
    func addMedia(urlImg:String, id_album:String, name:String, descrip:String, type:Int, duration:String, height:Double, weight:Double ,responseSuccess:@escaping (ResponseData) -> Void){
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
                    
                    self.getAlbumDetail(idAlbum: id_album)
                }
            case .failure(let error):
                responseSuccess(ResponseData(status: 500, message: "Ocurrio un error"))
                print("error media",error)
            }
        }
        
    }
    
    func getAlbumDetail(idAlbum:String){
        urlImagesAlbum = []
        picktureList = []
        matrizPick = []
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums/\(idAlbum)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let requestAF = Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            requestAF.responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    //print(json)
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else {
                            return
                        }
                        guard let pictures = data["pictures"] as? NSArray else{
                            return
                        }
                        print("lista original imagenes: ",pictures)
                        self.picktureList = []
                        self.arrayConst = []
                        for pic in pictures {
                            guard let p = pic as? NSDictionary else {
                                return
                            }
                            let urlimg = p["url"] as? String ?? ""
                            let album_id = p["album_id"] as? String ?? ""
                            let id_img = p["id"]  as? String ?? ""
                            let order = p["order"] as? Int ?? 0
                            var user_name = ""
                            var username = ""
                            let user = p["user"] as! NSDictionary
                            user_name = user["name"] as? String ?? ""
                            username = user["username"] as? String ?? ""
                            let user_id = user["user_id"] as! String
                            let user_url = user["url"] as? String ?? ""
                            let duration = p["duration"] as? String ?? "0:0"
                            let tipo = p["type"] as! Int
                            let description = p["description"] as? String ?? ""
                            let namePickture = p["name"] as? String ?? ""
                            let alto = p["height"] as? String ?? "0"
                            let ancho = p["weight"] as? String ?? "0"
                            var ratio = 0.0
                            var anchoD = 0.0
                            var altoD = 0.0
                            if let doubleAncho = Double(ancho) {
                                anchoD = doubleAncho
                            }
                            if let doubleAlto = Double(alto) {
                                altoD = doubleAlto
                            }
                            ratio = anchoD / altoD
                            
                            if tipo == 1 {
                                self.arrayConst.append(pickture(album_id: album_id, id_img: id_img, order: order, url: URL(string:urlimg)!, user_id: user_id, user: user_name, user_name: username , image: UIImage(), tipo: 1, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: altoD, ancho: anchoD, ratio: ratio))
                                self.picktureList = self.arrayConst.sorted {$0.order > $1.order}
                                self.createMatriz(pickturesList: self.picktureList)
                            } else {
                                self.getImagePrevVidio(from: urlimg, album_id: album_id, id_img: id_img, order: order, url: url, user_id: user_id, user: user_name, user_name: username, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: altoD, ancho: anchoD, ratio: ratio) { img in
                                    self.arrayConst.append(img)
                                    self.picktureList = self.arrayConst.sorted {$0.order > $1.order}
                                    self.createMatriz(pickturesList: self.picktureList)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAlbumDetailMatrix(idAlbum:String){
        picktureListMatrix = []
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums/\(idAlbum)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let requestAF = Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            requestAF.responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    //print(json)
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else {
                            return
                        }
                        guard let pictures = data["pictures"] as? NSArray else{
                            return
                        }
                        print("lista original imagenes: ",pictures)
                        self.picktureListMatrix = []
                        self.arrayConstMatrix = []
                        for pic in pictures {
                            guard let p = pic as? NSDictionary else {
                                return
                            }
                            let urlimg = p["url"] as? String ?? ""
                            let album_id = p["album_id"] as? String ?? ""
                            let id_img = p["id"]  as? String ?? ""
                            let order = p["order"] as? Int ?? 0
                            var user_name = ""
                            var username = ""
                            let user = p["user"] as! NSDictionary
                            user_name = user["name"] as? String ?? ""
                            username = user["username"] as? String ?? ""
                            let user_id = user["user_id"] as! String
                            let user_url = user["url"] as? String ?? ""
                            let duration = p["duration"] as? String ?? "0:0"
                            let tipo = p["type"] as! Int
                            let description = p["description"] as? String ?? ""
                            let namePickture = p["name"] as? String ?? ""
                            let alto = p["height"] as! String
                            let ancho = p["weight"] as! String
                            var ratio = 0.0
                            var anchoD = 0.0
                            var altoD = 0.0
                            if let doubleAncho = Double(ancho) {
                                anchoD = doubleAncho
                            }
                            if let doubleAlto = Double(alto) {
                                altoD = doubleAlto
                            }
                            ratio = anchoD / altoD
                            if tipo == 1 {
                                self.arrayConstMatrix.append(pickture(album_id: album_id, id_img: id_img, order: order, url: URL(string:urlimg)!, user_id: user_id, user: user_name, user_name: username , image: UIImage(), tipo: 1, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: altoD, ancho: anchoD, ratio: ratio))
                                self.picktureListMatrix = self.arrayConstMatrix.sorted {$0.order > $1.order}
                                self.createMatriz(pickturesList: self.picktureListMatrix)
                            } else {
                                self.getImagePrevVidio(from: urlimg, album_id: album_id, id_img: id_img, order: order, url: url, user_id: user_id, user: user_name, user_name: username, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: altoD, ancho: anchoD, ratio: ratio) { img in
                                    self.arrayConstMatrix.append(img)
                                    self.picktureListMatrix = self.arrayConstMatrix.sorted {$0.order > $1.order}
                                    self.createMatriz(pickturesList: self.picktureListMatrix)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImagePrevVidio(from urlString: String,album_id: String, id_img: String, order: Int, url: String, user_id: String, user: String, user_name:String, user_url:String, duration:String, description: String, namePickture: String, alto:Double, ancho:Double, ratio:Double, completion: @escaping (pickture) -> Void){
        if let url = URL(string:urlString) {
            AVAsset(url: url).generateThumbnail { (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    completion(pickture(album_id: album_id, id_img: id_img, order: order, url: URL(string:urlString)!, user_id: user_id, user: user, user_name: user_name, image: image, tipo: 2, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: alto, ancho: ancho, ratio: ratio))
                }
            }
        }
    }
    
    func getImage(from urlString: String,album_id: String, id_img: String, order: Int, url: String, user_id: String, user: String, user_name:String, user_url:String, duration:String, description: String, namePickture: String, alto:Double, ancho:Double, ratio:Double, completion: @escaping (pickture) -> Void) {
        // Verificar si la URL es válida
        guard let url = URL(string: urlString) else {
            //completion()
            return
        }
        // Realizar una solicitud de red para descargar la imagen
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Verificar si hubo un error
            if let error = error {
                print("Error al descargar la imagen: \(error.localizedDescription)")
                //completion(nil)
                return
            }
            
            // Verificar si se recibieron datos de la respuesta
            guard let data = data else {
                //completion(nil)
                return
            }
            
            // Crear un UIImage a partir de los datos descargados
            if let image = UIImage(data: data) {
                if let imgCp = image.jpegData(compressionQuality: 0.8) {
                    if let imagenComprimida = UIImage(data: imgCp) {
                        completion(pickture(album_id: album_id, id_img: id_img, order: order, url: URL(string:urlString)!, user_id: user_id, user: user, user_name: user_name, image: imagenComprimida, tipo: 1, user_url: user_url, duration: duration, description: description, namePickture: namePickture, alto: alto, ancho: ancho, ratio: ratio))
                    }
                }
            } else {
                //completion(nil)
            }
        }.resume()
    }
    
    func getAlbumListFriend(id_user:String, lenguaje:String, result:@escaping ([ElsesAlbumInfo]) -> Void){
        albumsFriend = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id_user)/albums"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("url albums friends", url)
        print("token", token)
        Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    //print("json albums", json)
                    guard let status = json["status"] as? Int else { return }
                    if status == 200 {
                        guard let data = json["data"] as? NSArray else { return}
                        //print(data)
                        for item in data{
                            if let i = item as? NSDictionary {
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
                                //let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                                if let actualizacion = dateformarGN.date(from: last_added_date) {
                                    let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                                    //let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion.timeIntervalSince1970))
                                    
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
                                //var iColaborator = false
                                
                                //print("soy colaborador: ",iColaborator)
                                let creado = lenguaje == "es" ? "Creado el" : "Created on"
                                let actualizado = lenguaje == "es" ? "Actualizado" : "Updated"
                                //let esAdmin = lenguaje == "es" ? "es" : "is"
                                let partici = lenguaje == "es" ? "Participantes" : "Participants"
                                
                                self.albumsFriend.append(ElsesAlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "\(nameAdmin.replacingOccurrences(of: " ", with: "")) \(lenguaje == "es" ? "es" : "is") admin", albumCreation: "\(creado) \(localDateC)", albumUpdate: "\(actualizado) \(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) \(partici)", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip))
                            }
                        }
                        result(self.albumsFriend)
                    } else {
                    }
                } else {
                }
            case .failure(let error):
                print("error albums",error)
            }
        }
        
    }
    
    func sendAlbumRequest(id_album:String, user:String, responseData:@escaping (ResponseData) -> Void){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums/requests/send"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let body : Parameters = [
            "album_id" : id_album,
            "user_to_send" : user
        ]
        
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    guard let status = json["status"] as? Int else { return }
                    if status == 200 {
                        let resp = ResponseData(status: 200, message: "Se envió la solicitud para compartir el álbum")
                        responseData(resp)
                    } else {
                        let resp = ResponseData(status: status, message: "Ya has enviado solicitud")
                        responseData(resp)
                    }
                    
                }
                
            case .failure(_):
                responseData(ResponseData(status: 500, message: "Error de conexion"))
            }
        }
    }
    
    func changeStatusPrivacy(idalbum:String, newPrivacy:Int, nombre:String, descrip:String, urlImg:String, responseData:@escaping (ResponseData) -> Void){
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "album_id":idalbum,
            //"name": nombre,
            //"description": descrip,
            //"url":urlImg,
            "privacy":newPrivacy
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("parametros del pryvacy",parameters, token)
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("album update",json)
                    guard let status = json["status"] as? Int else {return}
                    if status == 200 {
                        responseData(ResponseData(status: 200, message: "La privacidad se actualizo con exito"))
                    } else {
                        responseData(ResponseData(status: 500, message: "No se pudo actualizar la privacidad"))
                    }
                }
            case .failure(let error):
                print("err", error)
                responseData(ResponseData(status: 500, message: "No se pudo actualizar la privacidad"))
            }
            
        }
        
    }
    
    func postImgToIntagram(urlImage:String){
        guard let instagramURL = URL(string: "instagram://app") else { return }
        if UIApplication.shared.canOpenURL(instagramURL) {
            // Instagram app is installed on the device
            let instagramShareURL = URL(string: "instagram-stories://share?media=\(urlImage)")
            UIApplication.shared.open(instagramShareURL!, options: [:], completionHandler: nil)
        } else {
            // Instagram app is not installed on the device
        }
    }
    
    func loadImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error al descargar la imagen: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No se pudieron obtener datos de la imagen")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("No se pudo crear la imagen a partir de los datos")
                completion(nil)
            }
        }.resume()
    }
    
    func sendUImageToInstagram(image:UIImage){
        if let urlScheme = URL(string: "instagram-stories://share?source_application=1589806501482849") {
            if UIApplication.shared.canOpenURL(urlScheme) {
                // Attach the pasteboard items
                let pasteboardItems: [[String: Any]] = [
                    ["com.instagram.sharedSticker.stickerImage": image,
                     "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                     "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"]
                ]
                
                // Set pasteboard options
                let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
                    .expirationDate: Date(timeIntervalSinceNow: 60 * 5)
                ]
                
                // This call is available on iOS 10+
                UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            } else {
                // Handle error cases
            }
        }
    }
    
    
    
    func acceptOrReplyColaboratingAlbum(album_id:String, user:String, accept:Int, responseData:@escaping (ResponseData) -> Void){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums/requests/reply"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let body : Parameters = [
            "album_id" : album_id,
            "user_to_reply" : user,
            "accept":accept
        ]
        
        print("paremetos cancelar solicitud: ",body)
        
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("rechazo al enviar solicitud: ",json)
                    guard let status = json["status"] as? Int else { return }
                    let mensaje = json["message"] as! String
                    if status == 200 {
                        let resp = ResponseData(status: 200, message: mensaje)
                        responseData(resp)
                    } else {
                        let resp = ResponseData(status: status, message: mensaje)
                        responseData(resp)
                    }
                    
                }
            case .failure(_):
                responseData(ResponseData(status: 500, message: "Error de conexion"))
            }
        }
    }
    
    func getInfoAlbumPanel(id_album:String, albumInfo:@escaping (AlbumInfo) -> Void){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums/\(id_album)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let i = json["data"] as? NSDictionary else {
                            return
                        }
                        print("info album", i)
                        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                        let owner_id = i["owner_id"] as? String ?? ""
                        let name = i["name"] as? String ?? ""
                        let descrip = i["description"] as? String ?? ""
                        let id = i["id"] as? String ?? ""
                        let url = i["url"] as? String ?? ""
                        let share_to = i["share_to"] as! NSArray
                        let privacy = i["privacy"] as! Int
                        let created_date = i["created_date"] as! NSDictionary
                        let last_added_date = i["last_added_date"] as! NSDictionary
                        let owner = i["owner"] as! NSDictionary
                        let nameAdmin = owner["username"] as? String ?? ""
                        
                        let creacion = created_date["_seconds"] as! Int
                        let actualizacion = last_added_date["_seconds"] as! Int
                        
                        let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                        ///let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion))
                        
                        let dateFormatter = DateFormatter()
                        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        dateFormatter.timeZone = .current
                        let localDateC = dateFormatter.string(from: dateC)
                        ///let localDateU = dateFormatter.string(from: dateU)
                        
                        var tipoAlbum = "Personal"
                        
                        if share_to.count > 0 {
                            tipoAlbum = lenguaje == "es" ? "Colaborativo" : "Collaborative"
                        }
                        
                        let timeInterval = NSDate().timeIntervalSince1970
                        
                        let interval = TimeInterval(actualizacion) - timeInterval
                        
                        let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                        let formatter = RelativeDateTimeFormatter()
                        if lenguaje == "es" {
                         formatter.locale = Locale(identifier: "es")
                        } else {
                            formatter.locale = Locale(identifier: "en")
                        }
                        formatter.unitsStyle = .abbreviated
                        let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                        
                        let colabs = i["colabs"] as! NSArray
                        
                        for c in colabs {
                            let colab = c as! NSDictionary
                            let c_user_id = colab["user_id"] as! String
                            let c_name = colab["name"] as! String
                            let c_username = colab["username"] as! String
                            let c_url = colab["url"] as! String
                            self.colaboradores.append(colaborador(user_id: c_user_id, name: c_name, url: c_url, username: c_username))
                        }
                        
                        let partici = lenguaje == "es" ? "Participantes" : "Participants"
                        
                        albumInfo(AlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "\(nameAdmin)", albumCreation: "\(localDateC)", albumUpdate: "\(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) \(partici)", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip, userOwner: nameAdmin, isCollap: false))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func reorderMedia(picktures:[pickture], id_album:String, user:String){
        let url =  "https://albums-pgobuckofq-uc.a.run.app/users/\(user)/albums/\(id_album)/media/order"
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        imagenesNewOrder = []
        let newPicks = picktures.reversed()
        for (index, pc) in newPicks.enumerated() {
            let singleImageDict:[String:Any] = [
                "id": pc.id_img,
                "order": index + 1
            ]
            imagenesNewOrder.append(singleImageDict as AnyObject)
        }
        
        let body:Parameters = [
            "media": imagenesNewOrder
        ]
        
        print(body)
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    if let status = json["status"] as? Int {
                        if status == 200 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            }
                        }
                    }
                }
            case .failure(let error):
                print("error order,",error)
            }
        }
    }
    
    func deleteAlbum(id:String, album:String, responseData:@escaping (ResponseData) -> Void) {
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums/\(album)"
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("eliminar album:", json)
                    let estatus = json["status"] as! Int
                    if estatus == 200 {
                        responseData(ResponseData(status: estatus, message: "el album se elimino con exito"))
                    } else {
                        responseData(ResponseData(status: estatus, message: "No se pudo eliminar album"))
                    }
                }
            case .failure(let error):
                print("error eliminar album", error)
            }
        }
    }
    
    func deleteMedia(id_user:String, id_album:String, id_media:String, responseData:@escaping (ResponseData) -> Void){
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id_user)/albums/\(id_album)/media?ids=\(id_media)"
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print(url, token)
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    let status = json["status"] as! Int
                    let mensaje = json["message"] as! String
                    if status == 200 {
                        responseData(ResponseData(status: status, message: mensaje))
                    } else {
                        responseData(ResponseData(status: status, message: mensaje))
                    }
                }
            case .failure(let error):
                print("error eliminar media", error)
            }
        }
    }
    
    func nuevoOrden(picktures:[pickture]) {
        
        
        
    }
    
    func createMatriz(pickturesList: [pickture]){
        
        // Supongamos que tienes un array de objetos llamado "miArray"
        let miArray2 = pickturesList

        // Creamos un nuevo array para almacenar los grupos de tres elementos
        var gruposDeTres: [[pickture]] = []

        // Iteramos sobre el array original en incrementos de tres
        for i in stride(from: 0, to: miArray2.count, by: 3) {
            // Extraemos el grupo de tres elementos o menos si estamos en el último grupo
            let grupo = Array(miArray2[i..<min(i + 3, miArray2.count)])
            
            // Agregamos el grupo al nuevo array
            gruposDeTres.append(grupo)
        }

        // Imprimimos el resultado
        matrizPick = gruposDeTres
    }
    
    func loadImage(url: URL, image:@escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                image(((UIImage(data: data) ?? UIImage(named: "placeholder"))!))
            }
        }.resume()
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
}
extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}


