//
//  User.swift
//  Stickjoy First Edition
//
//  Created by admin on 22/08/23.
//

import Foundation

struct Response:Decodable, Identifiable {
    let id: Int
    let status:String
    let data:DataUser
    let message:String
}

struct DataUser:Codable {
    let id: String
    let alt_id: Int
    let name: String
    let email: String
    let password:String
    let url: String
    let description: String
    let username: String
    let is_premium: Bool
}
