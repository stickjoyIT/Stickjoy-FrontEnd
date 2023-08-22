//
//  ProfileInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Paulo: Este file es mega importante, porque aquí vendrá la info del usuario, sus amigos, etc. 

import Foundation

struct ProfileInfo {
    static var profileName: String = "John" // Replace with actual profile name
    static var profileImage: String = "profilePicture" // Reemplazar por imagen de perfil real
    static var profileUsername: String = "@johndoe" // Reemplazar por nombre de usuario real
    static var profileDescription: String = "Welcome to my Stickjoy Profile, enjoy it." //Reemplazar por la descripción de perfil real
}


struct ProfileFriendsAndRequests {
    //Aquí va la lista de amigos del usuario
    static let friendsList: [String] = ["Friend X", "Friend Y", "Friend Z"]
    
    //Aquí va la lista de solicitudes de colaboración del usuario
    static let pendingCollabRequests: [String] = ["User A", "User B", "User C"]
}

struct ProfileAnchoredProfiles: Identifiable {
    var id = UUID().uuidString
    var anchoredProfileName: String
    var anchoredProfileUsername: String
    var anchoredProfilePicture: String
}

var anchoredprofile = [
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
    ProfileAnchoredProfiles(anchoredProfileName: "Johny", anchoredProfileUsername: "@johndoe", anchoredProfilePicture: "profilePicture"),
]

//Notificaciones de este usuario (Inbox)
enum NotificationType {
    case friendRequest(profilename: String, username: String, image: String)
    case collaborationRequest(albumAdmin: String, albumName: String, image: String)
}

struct Notification: Identifiable {
    var id = UUID()
    var type: NotificationType
}

let inboxNotifications: [Notification] = [
    //Solicitudes de Amistad recibidas
    Notification(type: .friendRequest(profilename: "John Doe", username: "@john_doe", image: "profilePicture")),
    Notification(type: .friendRequest(profilename: "Jane Smith", username: "@jane_smith", image: "profilePicture")),
    
    //Solicitudes de Colaboración recibidas
    Notification(type: .collaborationRequest(albumAdmin: "Paola García", albumName: "Summer Vacations", image: "profilePicture")),
    Notification(type: .collaborationRequest(albumAdmin: "Paola García", albumName: "The Highscool Pics", image: "profilePicture")),
    // Add more notifications here...
]



//Solicitudes enviadas de este usuario (Outbox)
enum RequestType {
    case friendRequestSent(profilename: String, username: String, image: String)
    case collaborationRequestSent(userInvited: String, albumName: String, image: String)
}

struct Request: Identifiable {
    var id = UUID()
    var type: RequestType
}

let outboxRequest: [Request] = [
    //Solicitudes de Amistad enviadas
    Request(type: .friendRequestSent(profilename: "Johnny M", username: "@john_doe", image: "profilePicture")),
    Request(type: .friendRequestSent(profilename: "Jane Smith", username: "@jane_smith", image: "profilePicture")),
    
    //Solicitudes de Colaboración enviadas
    Request(type: .collaborationRequestSent(userInvited: "Paola García", albumName: "Summer Vacations", image: "profilePicture")),
    Request(type: .collaborationRequestSent(userInvited: "Paola García", albumName: "The Highscool Pics", image: "profilePicture")),
    // Add more notifications here...
]



//Lista de amigos del usuario (Friends List)
struct friendsList: Identifiable {
    var id = UUID().uuidString
    var image: String
    var profilename: String
    var username: String
}

var friendslist = [
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
    friendsList(image: "profilePicture", profilename: "Nombre de Pila", username: "Nombre de Usuario"),
]
