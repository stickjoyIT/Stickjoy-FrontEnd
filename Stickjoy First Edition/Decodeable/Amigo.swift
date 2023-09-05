//
//  Amigo.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import Foundation

struct Amigo:Identifiable {
    var id = UUID()
    var user_id:String
    var name:String
    var username:String
    var user_url:String
    var album_id:String
    var album_name:String
    var album_description:String
    var album_url:String
    var picture_id:String
    var picture_url:String
    var picture_created_date:String
}
