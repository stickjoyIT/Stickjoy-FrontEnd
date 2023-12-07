//
//  ProfileHeaderView.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//

import SwiftUI
import Alamofire
import Firebase

class ProfileViewModel: ObservableObject{
    @Published var offset: CGFloat = 0

    func updateProfile(name:String, descrip:String, urlImg:String){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = "https://users-pgobuckofq-uc.a.run.app/users/:id"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parametros: Parameters = [
            "name": name,
            "description": descrip,
            "url":urlImg
        ]
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
    
    func observedObject(){
        
    }
}
