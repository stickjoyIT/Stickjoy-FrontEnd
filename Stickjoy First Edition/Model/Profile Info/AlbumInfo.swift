//
//  AlbumInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//

import SwiftUI

// Albums

struct AlbumInfo: Identifiable {
    var id = UUID().uuidString
    var albumTitle: String
    var albumImage: String
    var albumAdministrator: String
    var albumCreation: String
    var albumUpdate: String
    var albumType: String
    var albumParticipants: String
    var albumPrivacy: Int
    var id_album:String
    var owner_id:String
    var description: String
    var userOwner:String
    var isCollap:Bool
}


var albumsinfo = [AlbumInfo]()
