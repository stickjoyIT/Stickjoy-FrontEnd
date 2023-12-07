//
//  UsuariosViewModel.swift
//  Stickjoy First Edition
//
//  Created by admin on 22/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

struct ResponseData {
    var status:Int
    var message:String
}
struct ResponseRegistroData {
    var status:Int
    var message:String
    var idUser:String
}
struct itemFeed:Identifiable {
    let id = UUID()
    var album_id:String
    var album_name:String
    var album_description:String
    var album_url:String
    var name:String
    var picture_created_date:String
    var picture_url:String
    var picture_description:String
    var picture_name:String
    var username:String
    var user_id:String
    var user_url:String
    var isNew:String
    var image:UIImage
    var tipo:Int
    var ratio:Double
}

let baseUrl = "https://users-pgobuckofq-uc.a.run.app"

struct StatusFriend {
    var frined:Bool
    var pinned:Bool
    var pend:Bool
}

final class UsuariosViewModel: ObservableObject {
    
    @Published var resgistro = true
    @Published var showAlert = false
    @Published var mensaje = ""
    @Published var loading = false
    @Published var feedList:[itemFeed] = [itemFeed]()
    @Published var amigoList = [Amigo]()
    @Published var amigoListPin = [Amigo]()
    @Published var inboxList = [Amigo]()
    @Published var outList = [Amigo]()
    @Published var UserElse = ElsesProfileInfo(profileName: "", profileImage: "", profileUsername: "", profileDescription: "")
    @Published var imgAmigo = ""
    @Published var colaboratorsList = [Amigo]()
    @Published var inboxAlbums = [Album]()
    
    @Published var name = ""
    @Published var username = ""
    @Published var descrip = ""
    
    @Published var isFriend = false
    @Published var isPinet = false
    @Published var isPending = false
    
    func registrarUsuario(name:String, correo:String, pass:String, confirm_pass:String, username:String, completion:@escaping (ResponseRegistroData)-> Void){
        loading = true
        guard let url = URL(string: baseUrl + "/users") else { return  }
        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        let parametros : Parameters = [
            "username":"@"+username,
            "name": name,
            "email": correo,
            "password":pass,
            "confirm_password":confirm_pass,
            "language":lenguaje == "es" ? 1 : 2
        ]
        Alamofire.request(url, method: .post, parameters: parametros, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as? Int ?? 0
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else{ return }
                        print("usuario registro", data)
                        let id = data["id"] as? String ?? ""
                        let token = data["token"] as! String
                        let nombre = data["name"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let descripcion = data["description"] as? String ?? ""
                        let url = data["url"] as? String ?? ""
                        let username = data["username"] as! String
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(nombre, forKey: "nombre")
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(descripcion, forKey: "descrip")
                        UserDefaults.standard.set(email, forKey: "correo")
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(url, forKey: "portada")
                        UserDefaults.standard.set(true, forKey: "notifications")
                        self.resgistro = true
                        self.showAlert = false
                        self.mensaje = json["message"] as? String ?? "Se ha mandado un correo para validar"
                        completion(ResponseRegistroData(status: status, message: self.mensaje, idUser: id))
                    } else {
                        self.resgistro = false
                        self.showAlert = true
                        self.mensaje = json["message"] as? String ?? ""
                        completion(ResponseRegistroData(status: status, message: self.mensaje, idUser: ""))
                    }
                }
                self.loading = false
            case .failure(let error):
                print("err registro",error)
                self.resgistro = false
                self.loading = false
                completion(ResponseRegistroData(status: 500, message: "Ocurrio un error", idUser: ""))
            }
        }
    }
    
    func updateUserInfo(name:String, descrip:String, urlImg:String, responseData:@escaping (ResponseData) -> Void){
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let parametros:Parameters = [
            "name": name,
            "description":descrip,
            "url":urlImg
        ]
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("url:",url)
        print("parametros actualiza:", parametros)
        print("token: \(token)")
        Alamofire.request(url, method: .put, parameters: parametros, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("response: ",json)
                    if let status = json["status"] as? Int {
                        if status == 200 {
                            responseData( ResponseData(status: status, message: "La actualizacion fue un exito"))
                        } else {
                            responseData( ResponseData(status: status, message: "Ocurrio un error al actualizar"))
                        }
                    }
                }
            case .failure(let error):
                print("erroe", error)
                responseData( ResponseData(status: 500, message: "Error de conexion"))
            }
        }
        
    }
    
    func loginUser(email:String, pass:String, compation:@escaping (Bool) -> Void){
        loading = true
        guard let url = URL(string: baseUrl + "/login") else { return  }
        
        let parametros:Parameters = [
            "email": email,
            "password":pass
        ]
        
        //print(parametros)
        
        Alamofire.request(url, method: .post, parameters: parametros).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    if let status = json["status"] as? Int {
                        if status == 200 {
                            if let data = json["data"] as? NSDictionary {
                                guard let user = data["user"] as? NSDictionary else {return}
                                print("datos usuario", user)
                                let nombre = user["name"] as? String ?? ""
                                let id = user["id"] as? String ?? ""
                                let token = data["token"] as! String
                                let email = user["email"] as? String ?? ""
                                let username = user["username"] as? String ?? ""
                                let description = user["description"] as? String ?? ""
                                let urlUserImg = user["url"] as? String ?? ""
                                UserDefaults.standard.set(true, forKey: "login")
                                UserDefaults.standard.set(token, forKey: "token")
                                UserDefaults.standard.set(nombre, forKey: "nombre")
                                UserDefaults.standard.set(username, forKey: "username")
                                UserDefaults.standard.set(description, forKey: "descrip")
                                UserDefaults.standard.set(id, forKey: "id")
                                UserDefaults.standard.set(email, forKey: "correo")
                                UserDefaults.standard.set(username, forKey: "username")
                                UserDefaults.standard.set(urlUserImg, forKey: "portada")
                                UserDefaults.standard.set(true, forKey: "notifications")
                                compation(true)
                                self.loading = false
                            } else {
                                self.loading = false
                                compation(false)
                            }
                        } else {
                            compation(false)
                            self.mensaje = json["message"] as? String ?? ""
                            self.loading = false
                        }
                    } else {
                        compation(false)
                        self.loading = false
                    }
                }
            case .failure(let error):
                print("error", error)
                compation(false)
                self.loading = false
            }
            
        }
        
    }
    
    func getFeedUser(feeds:@escaping (ResponseData) -> Void) {
        feedList = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        let url = "https://albums-pgobuckofq-uc.a.run.app/feed"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    let status = json["status"] as? Int ?? 400
                    if status == 200 {
                        feeds(ResponseData(status: status, message: ""))
                        guard let data = json["data"] as? NSArray else{return}
                        if data.count > 0 {
                            print("si tiene feed")
                            UserDefaults.standard.set(true, forKey: "isFeed")
                        } else {
                            UserDefaults.standard.set(false, forKey: "isFeed")
                        }
                        for feed in data {
                            guard let f = feed as? NSDictionary else {return}
                            print("feedItem", f)
                            let album_url = f["album_url"] as? String ?? ""
                            let album_description = f["album_description"] as? String ?? ""
                            let album_id = f["album_id"] as? String ?? ""
                            let album_name = f["album_name"] as? String ?? ""
                            let picture_created_date = f["picture_created_date"] as? String ?? ""
                            _ = f["picture_id"] as? String ?? ""
                            let picture_url = f["picture_url"] as? String ?? ""
                            let pictureName = f["picture_name"] as? String ?? ""
                            let picture_description = f["picture_description"] as? String ?? ""
                            let tipo = f["type"] as! Int
                            let alto = f["height"] as? String ?? "0.0"
                            let ancho = f["weight"] as? String ?? "0.0"
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
                            var user_id = f["user_id"] as? String ?? ""
                            var nameUser = f["name"] as? String ?? ""
                            var username = f["username"] as? String ?? ""
                            var user_url = ""
                            if let user_obj = f["picture_user"] as? NSDictionary {
                                if let user_url_v = user_obj["url"] as? String {
                                    user_url = user_url_v
                                }
                                user_id = user_obj["user_id"] as? String ?? ""
                                nameUser = user_obj["name"] as? String ?? ""
                                username = user_obj["username"] as? String ?? ""
                            }
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "es_MX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            formatter.timeZone = TimeZone(identifier: "UTC")
                            let currentDate = Date()
                            
                            let calendar = Calendar.current
                            let formattedDate = formatter.date(from: picture_created_date)
                            
                            let components = calendar.dateComponents([.day], from: formattedDate ?? currentDate, to: currentDate)
                            let dias = components.day ?? 2
                            var new = lenguaje == "es" ? "Nuevo" : "New"
                            if dias > 1 {
                                new = ""
                            }
                            var creado = ""
                            let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                            if let actualizacion = formatter.date(from: picture_created_date) {
                                let timeInterval = NSDate().timeIntervalSince1970
                                
                                let interval =  TimeInterval(actualizacion.timeIntervalSince1970) - timeInterval
                                let exampleDate = Date().addingTimeInterval(TimeInterval(interval))
                                let formatter = RelativeDateTimeFormatter()
                                if lenguaje == "es" {
                                 formatter.locale = Locale(identifier: "es")
                                } else {
                                    formatter.locale = Locale(identifier: "en")
                                }
                                formatter.unitsStyle = .abbreviated
                                creado = formatter.localizedString(for: exampleDate, relativeTo: Date())
                            }
                            DispatchQueue.main.async {
                                self.feedList.append(itemFeed(album_id:album_id, album_name: album_name, album_description: album_description, album_url: album_url, name: nameUser, picture_created_date: "\(creado)", picture_url: picture_url, picture_description: picture_description, picture_name: pictureName, username: username, user_id: user_id, user_url: user_url, isNew: new, image: UIImage(), tipo: tipo, ratio: ratio))
                            }
                        }
                    } else {
                        feeds(ResponseData(status: status, message: ""))
                    }
                }
            case .failure(let error):
                print(error)
                feeds(ResponseData(status: 500, message: ""))
            }
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
    
    func searchUser(search: String, compation:@escaping ([Amigo]) -> Void){
        print("buscar")
        loading = true
        amigoList = []
        compation(amigoList)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/list/search?u=@\(search)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    print(json)
                    if status == 200 {
                        
                        guard let data = json["data"] as? NSArray else {
                            return
                        }
                        
                        for d in data {
                            guard let i = d as? NSDictionary else {
                                return
                            }
                            
                            let id = i["id"] as? String ?? ""
                            let description = i["description"] as? String ?? "Welcome"
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let url = i["url"] as? String ?? ""
                            
                            self.amigoList.append(Amigo(user_id: id, name: name, username: username.replacingOccurrences(of: " ", with: ""), user_url: url, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                        compation(self.amigoList)
                    }
                    self.loading = false
                }
            case .failure(let error):
                print(error)
                self.loading = false
            }
        }
    }
    
    func getUserDetails(user_id:String, imgP:@escaping (String) -> Void){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(user_id)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                       // print("info_amigo:", data)
                        let name = data["name"] as? String ?? ""
                        let username = data["username_lowercase"] as? String ?? ""
                        let img = data["url"] as? String ?? ""
                        let desc = data["description"] as? String ?? "Welcome"
                        imgP(img)
                        self.UserElse = ElsesProfileInfo(profileName: name, profileImage: img, profileUsername: username, profileDescription: desc)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func getUserPinetOrFriend(id_elseuser:String, result:@escaping (StatusFriend) -> Void){
        isFriend = false
        isPinet = false
        isPending = false
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        print("Cosulto mi usuario:",id_elseuser)
                        print(data)
                        guard data["incoming_request"] is NSArray else{return}
                        //print(incoming_request.count)
                        guard let friends = data["friends"] as? NSArray else{return}
                        guard let pinned_users = data["pinned_users"] as? NSArray else{return}
                        //print("userpin",pinned_users.count)
                        guard let outgoing_request = data["outgoing_request"] as? NSArray else{return}
                        //print("outgoing_request",outgoing_request.count)
                        for friend in friends {
                            guard let f = friend as? NSDictionary else {return}
                            let id_friend = f["user_id"] as! String
                            if id_friend == id_elseuser {
                                self.isFriend = true
                            }
                        }
                        for pinned_user in pinned_users {
                            guard let f = pinned_user as? NSDictionary else {return}
                            let id_pin_user = f["user_id"] as! String
                            if id_pin_user == id_elseuser {
                                self.isPinet = true
                            }
                        }
                        for ou in outgoing_request {
                            guard let f = ou as? NSDictionary else {return}
                            let id_pin_user = f["user_id"] as! String
                            if id_pin_user == id_elseuser {
                                self.isPending = true
                            }
                        }
                        let estatus = StatusFriend(frined: self.isFriend, pinned: self.isPinet, pend: self.isPending)
                        result(estatus)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserPineds(){
        amigoListPin = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        guard let pinned_users = data["pinned_users"] as? NSArray else{return}
                        print("usuarios_pin:",pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let url = i["url"] as? String ?? ""
                            
                            self.amigoListPin.append(Amigo(user_id: id, name: name, username: username, user_url: url, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserOutList(){
        outList = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        //print("data del album", data)
                        guard let pinned_users = data["outgoing_request"] as? NSArray else{return}
                        guard let out_albums_request = data["outgoing_request_albums"] as? NSArray else {return}
                        //print("solicitudes enviadas de albums pendientes",out_albums_request)
                        for albums_req in out_albums_request {
                            guard let i = albums_req as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let url = i["user_url"] as? String ?? ""
                            let name_album = i["album"] as? String ?? ""
                            let album_id = i["album_id"] as? String ?? ""
                            let album_url = i["album_url"] as? String ?? ""
                            
                            self.outList.append(Amigo(user_id: id, name: name, username: username, user_url: url, album_id: album_id, album_name: name_album, album_description: description, album_url: album_url, picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let url = i["url"] as? String ?? ""
                            
                            self.outList.append(Amigo(user_id: id, name: name, username: username, user_url: url, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserInBoxList(){
        inboxList = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        guard let pinned_users = data["incoming_request"] as? NSArray else{return}
                        print("inbox user", pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let urlA = i["url"] as? String ?? ""
                            
                            self.inboxList.append(Amigo(user_id: id, name: name, username: username, user_url: urlA, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getUserInBoxListAlbum(){
        inboxAlbums = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        guard let pinned_users = data["incoming_request_albums"] as? NSArray else{return}
                        print("solicitudes de albums",pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let album_id = i["album_id"] as! String
                            let description = ""
                            let album_name = i["album"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let album_img = i["album_url"] as? String ?? ""
                            self.inboxAlbums.append(Album(owner_id: username, name: album_name, description: description, id_alb: album_id, url: album_img, user_id: id))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pinUser(id_usuario:String, responseReturn:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/users/pin"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params:Parameters = [
            "id": id_usuario
        ]
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    
    func unPinUser(id_usuario:String, responseReturn:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/users/unpin"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params:Parameters = [
            "id": id_usuario
        ]
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    
    func sendFriendReq(id_usuario:String, responseReturn:@escaping (ResponseData) -> Void) {
        let url = "https://users-pgobuckofq-uc.a.run.app/users/friends/requests/send"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params:Parameters = [
            "user_to_send": id_usuario
        ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    
    func sendFriendReply(id_usuario:String, responseReturn:@escaping (ResponseData) -> Void) {
        let url = "https://users-pgobuckofq-uc.a.run.app/users/friends/requests/reply"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params:Parameters = [
            "user_to_reply": id_usuario,
            "accept": 0
        ]
        print(params)
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    print(message)
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    
    func sendFriendAcept(id_usuario:String, responseReturn:@escaping (ResponseData) -> Void) {
        let url = "https://users-pgobuckofq-uc.a.run.app/users/friends/requests/reply"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params:Parameters = [
            "user_to_reply": id_usuario,
            "accept": 1
        ]
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    func getFriends(amigos:@escaping ([Amigo]) -> Void){
        colaboratorsList = []
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let id_user = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    guard let status = json["status"] as? Int else {
                        return
                    }
                    if status == 200 {
                        guard let data = json["data"] as? NSDictionary else { return }
                        guard let pinned_users = data["friends"] as? NSArray else{return}
                        print("mis amigos", pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let urlA = i["url"] as? String ?? ""
                            
                            self.colaboratorsList.append(Amigo(user_id: id, name: name, username: username.replacingOccurrences(of: " ", with: ""), user_url: urlA, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
                        }
                        amigos(self.colaboratorsList)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func forGotPassword(email:String, responseReturn:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/recovery/password"
        let lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        let params:Parameters = [
            "email": email,
            "language": lenguaje == "es" ? 1 : 2
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    func deleteFriend(friend_id:String, responseReturn:@escaping (ResponseData) -> Void){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id)/friends/\(friend_id)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("id amigo eliminado: ", friend_id)
        print("url elimina amigo:", url)
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    //print(json)
                    let status = json["status"] as! Int
                    let message = json["message"] as! String
                    
                    responseReturn(ResponseData(status: status, message: message))
                }
            case .failure(let error):
                print(error)
                let resp = ResponseData(status: 500, message: "Error de conexion")
                responseReturn(resp)
            }
        }
    }
    
    func resendPin(email:String, responseData:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/resend/pin"
        let body:Parameters = [
            "email":email
        ]
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("reeenviar pin",json)
                    let status = json["status"] as! Int
                    let mensaje = json["data"] as! String
                    responseData(ResponseData(status:status, message: mensaje))
                }
            case .failure(let error):
                responseData(ResponseData(status:500, message: "Algo salio mal \(error)"))
            }
        }
    }
    
    func validatePinCode(email:String, pin:Int, responseData:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/pin-validation"
        let body:Parameters = [
            "email": email,
            "pin": pin
        ]
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON {response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    let mensaje = json["message"] as? String ?? ""
                    responseData(ResponseData(status:status, message: mensaje))
                }
            case .failure(let error):
                print(error)
                responseData(ResponseData(status:500, message: "Ocurrio un error"))
            }
        }
    }
    func deleteInactiveUser(idUser:String, responseData:@escaping (ResponseData) -> Void) {
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(idUser)/inactive"
        Alamofire.request(url, method: .delete).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    let status = json["status"] as! Int
                    let mensaje = json["message"] as! String
                    responseData(ResponseData(status:status, message: mensaje))
                }
            case .failure(let error):
                print(error)
                responseData(ResponseData(status:500, message: "Algo salio mal \(error)"))
            }
        }
    }
    
    func deleteAccount(id_user:String, responseData:@escaping (ResponseData) -> Void){
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    let status = json["status"] as! Int
                    let mensaje = json["message"] as! String
                    responseData(ResponseData(status:status, message: mensaje))
                }
            case .failure(let error):
                print(error)
                responseData(ResponseData(status:500, message: "Algo salio mal \(error)"))
            }
        }
    }
    
    func saveIdNotification(id_device:String, id_user:String){
        let url = "https://users-pgobuckofq-uc.a.run.app/users/notifications/devices"
        
        let body:Parameters = [
            "id": id_user,
            "device": id_device
        ]
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteIdDevice(id_device:String, id_user:String){
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)/notifications/devices/\(id_device)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDevicesUser(id_user:String, devices:@escaping ([String]) -> Void) {
        let url = "https://users-pgobuckofq-uc.a.run.app/users/\(id_user)/notifications/devices"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    let status = json["status"] as! Int
                    if status == 200 {
                        let data = json["data"] as! NSDictionary
                        let devicesArr = data["devices"] as! [String]
                        devices(devicesArr)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func sendNotificationPush(titulo:String, body:String, token:String){
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
                    var request = URLRequest(url: url)
                    request.allHTTPHeaderFields = ["Authorization": "key=AAAAXTDFlWM:APA91bFK_idBldpqkeHglQTBWE6kZliwNbOSvtGV9utVqM9LbxmKVNd2qU9DT6x9OejceHRvVQlUydlkbBOYW8lKa1yxJlt1Ikoy9BulXsiwC-gdi0n0YXpuftAZyqAvl099hSXCFywq", "Content-Type":"application/json"]
                    request.httpMethod = "POST"
                    let parametros = ["to":token,
                                      "priority":"high",
                                      "notification":[
                                        "title":titulo,
                                        "body":body,
                                        "sound":"true",
                                        "badge":"1"]] as [String: Any]
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parametros, options: JSONSerialization.WritingOptions())
                        print("parametros: ", parametros)
                    } catch let error as NSError {
                        print("error en notificacion", error.localizedDescription)
                    }
                    
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        print("error al enviar", error as Any)
                    }.resume()
                    
                }
    }
    
    func deleteColaborator(album_id:String, colab_id:String, responseData:@escaping (ResponseData) -> Void){
        let myid = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/users/\(myid)/albums/\(album_id)/colabs/\(colab_id)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("url: ", url)
        print("token: ", token)
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print("delete colab:", json)
                    let status = json["status"] as! Int
                    let mensaje = json["message"] as! String
                    responseData(ResponseData(status:status, message: mensaje))
                }
            case .failure(let error):
                print(error)
                responseData(ResponseData(status:500, message: "Ocurrio un error"))
            }
        }
    }
    
}
