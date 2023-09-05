//
//  Album.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import Foundation

struct Album:Identifiable {
    let owner_id: String
    let name: String
    let description: String
    var id = UUID().uuidString
    let id_alb:String
    let url: String
}
