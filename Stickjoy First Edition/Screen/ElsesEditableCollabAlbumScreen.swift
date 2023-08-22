//
//  ElsesEditableCollabAlbumScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre de Lista de Requerimientos: 17. Pantalla de Edición de Álbum Colaborativo Ajeno.
//  Paulo: Al hacer esta pantalla, es igual que EditableAlbumScreen, solo que no puedes editar nombre, foto, descripción, y solo puedes eliminar las fotos que tu subiste porque no eres admin.

import SwiftUI

struct ElsesEditableCollabAlbumScreen: View {
    var body: some View {
        Text("Editar un álbum que no es mio pero participo. ")
    }
}

struct ElsesEditableCollabAlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        ElsesEditableCollabAlbumScreen()
    }
}
