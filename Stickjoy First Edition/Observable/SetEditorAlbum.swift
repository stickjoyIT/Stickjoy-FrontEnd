//
//  SetEditorAlbum.swift
//  Stickjoy First Edition
//
//  Created by admin on 24/08/23.
//

import Foundation
import SwiftUI
import Combine

class SetEditor: ObservableObject {
    @Published var editor : Bool = false
    @Published var nameAlbum: String = "Nombre del Álbum"
    @Published var descripAlbum:String = "Bienvenid@ a mi nuevo álbum"
    @Published var imgPortada = ""
    @Published var imgPortadaP = UserDefaults.standard.string(forKey: "portada") ?? ""
}
