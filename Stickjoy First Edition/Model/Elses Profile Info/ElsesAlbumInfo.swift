//
//  ElsesAlbumInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//

import SwiftUI

// Albums

struct ElsesAlbumInfo: Identifiable {
    var id = UUID().uuidString
    var albumTitle: String
    var albumImage: String
    var albumAdministrator: String
    var albumCreation: String
    var albumUpdate: String
    var albumType: String
    var albumParticipants: String
    var albumPrivacy: String
}


var elsesalbumsinfo = [
    
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
    ElsesAlbumInfo(albumTitle: "My Trip to Yellowstone", albumImage: "uploadedPicture2", albumAdministrator: "@nombredeusuario is admin", albumCreation: "Created on 25/09/2023", albumUpdate: "Updated 22h ago", albumType: "Collaborative", albumParticipants: "5 participants", albumPrivacy: "Public"),
]
