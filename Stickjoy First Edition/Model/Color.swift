//
//  Color.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Paulo: En este archivo se guardan los colores de stickjoy.

import SwiftUI

extension Color {
    //Amarillo Stickjoy oficial
    static let customYellow = Color(hex: 0xFFD966)
    
    //Azul Stickjoy oficial
    static let customBlue = Color(hex: 0x8DB8E0)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}
