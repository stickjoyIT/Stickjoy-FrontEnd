//
//  FullSizeScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 10. Pantalla de Full Size
//  Paulo: Falta lo del botón que oculta y muestra la información.
//  ¿Qué falta?: Corregir lo de que se ve gris la info.

import SwiftUI

struct FullSizeScreen: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(0..<20) { index in
                    NavigationLink(destination: FullSizeItem()) {
                        FullSizeItem()
                    }
                }
            }
        }
    }
}

struct FullSizeScreen_Previews: PreviewProvider {
    static var previews: some View {
        FullSizeScreen()
    }
}
