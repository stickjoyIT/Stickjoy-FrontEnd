//
//  AlbunViewModel.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlbumViewModel : ObservableObject {
    
    @Published var listAlbum = [AlbumInfo]()
    @Published var mensaje = ""
    @Published var modoEditor = false
    @Published var loading = false
    @Published var urlImagesAlbum = [String]()
    @Published var albumsFriend = [ElsesAlbumInfo]()
    
    func getAlbumList(compation:@escaping ([AlbumInfo]) -> Void){
        listAlbum = []
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("json albums", json)
                    guard let status = json["status"] as? Int else { return }
                    if status == 200 {
                        guard let data = json["data"] as? NSArray else { return}
                        print(data)
                        for item in data{
                            if let i = item as? NSDictionary {
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
                                let nameAdmin = owner["name"] as! String
                                
                                let creacion = created_date["_seconds"] as! Int
                                let actualizacion = last_added_date["_seconds"] as! Int
                                
                                let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                                let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion))
                                
                                let dateFormatter = DateFormatter()
                                //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                dateFormatter.timeZone = .current
                                let localDateC = dateFormatter.string(from: dateC)
                                let localDateU = dateFormatter.string(from: dateU)
                                
                                var tipoAlbum = "Personal"
                                
                                if share_to.count > 0 {
                                    tipoAlbum = "Colaborativo"
                                }
                                
                                let timeInterval = NSDate().timeIntervalSince1970
                                
                                let interval = TimeInterval(actualizacion) - timeInterval
                                
                                let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                                let formatter = RelativeDateTimeFormatter()
                                formatter.unitsStyle = .full
                                let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                                
                                let nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
                                
                                self.listAlbum.append(AlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "@\(nameAdmin.replacingOccurrences(of: " ", with: "")) es admin", albumCreation: "Creado el \(localDateC)", albumUpdate: "Actualizado \(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) Participantes", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip))
                            }
                        }
                        compation(self.listAlbum)
                    } else {
                        compation([])
                    }
                } else {
                    compation([])
                }
            case .failure(let error):
                print("error albums",error)
                compation([])
            }
        }
        
    }
    
    func setModoEditor(modo:Bool){
        modoEditor = modo
    }
    
    func createAlbum(nombre:String, descripcion:String, urlImg:String, descrip:String, compation:@escaping (Bool) -> Void, result:@escaping (String) -> Void){
        loading = true
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "name": nombre,
            "description": descrip,
            "url":urlImg,
            "privacy":1
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
    
    func updateAlbum(album_id:String, nombre:String, descripcion:String, urlImg:String, descrip:String, compation:@escaping (Bool) -> Void, result:@escaping (String) -> Void){
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "album_id":album_id,
            "name": nombre,
            "description": descrip,
            "url":urlImg,
            "privacy":2
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("parametros del album",parameters)
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                }
            case .failure(let error):
                print("err", error)
                compation(false)
                result("")
            }
            
        }
        
    }
    
    func addMedia(urlImg:String, id_album:String, responseSuccess:@escaping (Bool) -> Void){
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/albums/\(id_album)/media"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameters:Parameters = [
            "url": "\(urlImg)"
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    responseSuccess(true)
                    self.getAlbumDetail(idAlbum: id_album, imagenes: {resp in})
                }
            case .failure(let error):
                responseSuccess(true)
                print("error media",error)
            }
        }
        
    }
    
    func getAlbumDetail(idAlbum:String, imagenes:@escaping ([String]) -> Void){
        urlImagesAlbum = []
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id)/albums/\(idAlbum)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("get album")
        Alamofire.request(url, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
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
                        for pic in pictures {
                            guard let p = pic as? NSDictionary else {
                                return
                            }
                            
                            let urlimg = p["url"] as? String ?? ""
                            self.urlImagesAlbum.append(urlimg)
                        }
                        imagenes(self.urlImagesAlbum)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAlbumListFriend(id_user:String){
        albumsFriend = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(id_user)/albums"
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("json albums", json)
                    guard let status = json["status"] as? Int else { return }
                    if status == 200 {
                        guard let data = json["data"] as? NSArray else { return}
                        print(data)
                        for item in data{
                            if let i = item as? NSDictionary {
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
                                let nameAdmin = owner["name"] as! String
                                
                                let creacion = created_date["_seconds"] as! Int
                                let actualizacion = last_added_date["_seconds"] as! Int
                                
                                let dateC = Date(timeIntervalSince1970: TimeInterval(creacion))
                                let dateU = Date(timeIntervalSince1970: TimeInterval(actualizacion))
                                
                                let dateFormatter = DateFormatter()
                                //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                dateFormatter.timeZone = .current
                                let localDateC = dateFormatter.string(from: dateC)
                                
                                var tipoAlbum = "Personal"
                                
                                if share_to.count > 0 {
                                    tipoAlbum = "Colaborativo"
                                }
                                
                                let timeInterval = NSDate().timeIntervalSince1970
                                
                                let interval = TimeInterval(actualizacion) - timeInterval
                                
                                let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                                let formatter = RelativeDateTimeFormatter()
                                formatter.unitsStyle = .full
                                let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
                                
                                let nameUser = UserDefaults.standard.string(forKey: "nombre") ?? ""
                                
                                self.albumsFriend.append(ElsesAlbumInfo(albumTitle: name, albumImage: url, albumAdministrator: "@\(nameAdmin.replacingOccurrences(of: " ", with: "")) es admin", albumCreation: "Creado el \(localDateC)", albumUpdate: "Actualizado \(relativeDate)", albumType: tipoAlbum, albumParticipants: "\(share_to.count) Participantes", albumPrivacy: privacy,id_album: id, owner_id: owner_id, description: descrip))
                            }
                        }
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
                        let resp = ResponseData(status: 200, message: "Se envió la solicitud para compartir el album")
                        responseData(resp)
                    } else {
                        let resp = ResponseData(status: status, message: "Ya has enviado solicitud")
                        responseData(resp)
                    }
                    
                }
                
            case .failure(let error):
                responseData(ResponseData(status: 500, message: "Error de conexion"))
            }
        }
    }
}
