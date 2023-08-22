//
//  DefaultAlbumInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import Foundation

struct DefaultAlbumContent {
    static var albumTitle: String = "My New Stickjoy Album" // Replace with actual profile name
    static var albumImage: String = "stickjoyLogoBlue" // Reemplazar por imagen de perfil real
    static var albumDescription: String = "Welcome to my new Stickjoy Album, enjoy it!" // Reemplazar por nombre de usuario real
    static var albumAdministrator: String = "@johndoe" //Reemplazar por la descripción de perfil real
    static var albumCreation: String = "Created on"
    static var albumUpdated: String = "Updated on"
    static var albumType: String = "Personal or Collaborative"
    static var albumParticipants: String = "5 Participants"
    static var albumPrivacy: String = "Public or Private or Just Friends"
    static var albumElements: String = "35 Elements"
    var albumContent: String
}

var albumcontent = [

    DefaultAlbumContent(albumContent: "You dont have content yet"),

]
