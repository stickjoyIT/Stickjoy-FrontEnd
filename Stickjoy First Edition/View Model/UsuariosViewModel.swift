//
//  UsuariosViewModel.swift
//  Stickjoy First Edition
//
//  Created by admin on 22/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ResponseData {
    var status:Int
    var message:String
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
    @Published var feedList = [Amigo]()
    @Published var amigoList = [Amigo]()
    @Published var amigoListPin = [Amigo]()
    @Published var inboxList = [Amigo]()
    @Published var outList = [Amigo]()
    @Published var UserElse = ElsesProfileInfo(profileName: "", profileImage: "", profileUsername: "", profileDescription: "")
    
    @Published var name = ""
    @Published var username = ""
    @Published var descrip = ""
    
    @Published var isFriend = false
    @Published var isPinet = false
    @Published var isPending = false
    
    func registrarUsuario(name:String, correo:String, pass:String, confirm_pass:String, completion:@escaping (Bool)-> Void){
        loading = true
        guard let url = URL(string: baseUrl + "/users") else { return  }
        
        let parametros : Parameters = [
            "name": name,
            "email": correo,
            "password":pass,
            "confirm_password":confirm_pass
        ]
        DispatchQueue.main.async {
            Alamofire.request(url, method: .post, parameters: parametros).responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String:Any] {
                        let status = json["status"] as? Int ?? 0
                        if status == 200 {
                            print("se registro")
                            guard let data = json["data"] as? NSDictionary else{ return }
                            let nombre = data["name"] as? String ?? ""
                            let id = data["id"] as? String ?? ""
                            let email = data["email"] as? String ?? ""
                            UserDefaults.standard.set(true, forKey: "login")
                            UserDefaults.standard.set("nombre", forKey: nombre)
                            UserDefaults.standard.set("id", forKey: id)
                            UserDefaults.standard.set("correo", forKey: email)
                            self.resgistro = true
                            self.showAlert = false
                            completion(true)
                        } else {
                            print(self.mensaje)
                            self.resgistro = false
                            self.showAlert = true
                            
                            self.mensaje = json["message"] as? String ?? ""
                            completion(false)
                        }
                    }
                    self.loading = false
                case .failure(let error):
                    print("err",error)
                    self.resgistro = false
                    self.loading = false
                    completion(false)
                }
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
        
        print(parametros)
        
        Alamofire.request(url, method: .post, parameters: parametros).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String:Any] {
                    print(json)
                    if let status = json["status"] as? Int {
                        if status == 200 {
                            if let data = json["data"] as? NSDictionary {
                                guard let user = data["user"] as? NSDictionary else {return}
                                let nombre = user["name"] as? String ?? ""
                                let id = user["id"] as? String ?? ""
                                let token = data["token"] as? String ?? ""
                                let email = user["email"] as? String ?? ""
                                let username = user["username"] as? String ?? ""
                                UserDefaults.standard.set(true, forKey: "login")
                                UserDefaults.standard.set(token, forKey: "token")
                                UserDefaults.standard.set(nombre, forKey: "nombre")
                                UserDefaults.standard.set(id, forKey: "id")
                                UserDefaults.standard.set(email, forKey: "correo")
                                UserDefaults.standard.set(username, forKey: "username")
                                compation(true)
                                self.loading = false
                            } else {
                                self.loading = false
                                compation(false)
                            }
                        } else {
                            compation(false)
                            self.mensaje = json["message"] as? String ?? "Vacio"
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
            }
            
        }
        
    }
    
    func getFeedUser() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = "https://albums-pgobuckofq-uc.a.run.app/feed"
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request(url, headers: headers).responseJSON { success in
            switch success.result {
            case .success:
                if let json = success.result.value as? [String:Any]{
                    print(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchUser(search: String, compation:@escaping ([Amigo]) -> Void){
        print("buscar")
        loading = true
        amigoList = []
        compation(amigoList)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/list/search?u=\(search)"
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
                            
                            self.amigoList.append(Amigo(user_id: id, name: name, username: username, user_url: url, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
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
    
    func getUserDetails(user_id:String){
        
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
                        
                        let name = data["name"] as? String ?? ""
                        let username = data["username_lowercase"] as? String ?? ""
                        let img = data["url"] as? String ?? ""
                        let desc = data["description"] as? String ?? "Welcome"
                                            
                        self.UserElse = ElsesProfileInfo(profileName: name, profileImage: img, profileUsername: "@"+username, profileDescription: desc)
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func getUserPinetOrFriend(id_elseuser:String, result:@escaping (StatusFriend) -> Void){
        
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
                        print(data)
                        guard let incoming_request = data["incoming_request"] as? NSArray else{return}
                        print(incoming_request.count)
                        guard let friends = data["friends"] as? NSArray else{return}
                        guard let pinned_users = data["pinned_users"] as? NSArray else{return}
                        print(pinned_users.count)
                        guard let outgoing_request = data["outgoing_request"] as? NSArray else{return}
                        print(outgoing_request.count)
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
                        print(pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["id"] as? String ?? ""
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
                        guard let pinned_users = data["outgoing_request"] as? NSArray else{return}
                        print(pinned_users)
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
                        print(pinned_users)
                        for pinned_user in pinned_users {
                            guard let i = pinned_user as? NSDictionary else {
                                return
                            }
                            let id = i["user_id"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            let username = i["username"] as? String ?? ""
                            let url = i["url"] as? String ?? ""
                            
                            self.inboxList.append(Amigo(user_id: id, name: name, username: username, user_url: url, album_id: "", album_name: "", album_description: description, album_url: "", picture_id: "", picture_url: "", picture_created_date: ""))
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
        print(params)
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
}
