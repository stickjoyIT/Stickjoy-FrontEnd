//
//  ElementsCountUploadScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 30/11/23.
//

import SwiftUI

struct ElementsCountUploadScreen: View {
    @Binding var numeroElementos:Int
    @Binding var porcent:Float
    @Binding var lenguaje:String
    @Environment (\.colorScheme) var scheme
    var body: some View {
        HStack {
            Text(lenguaje == "es" ? "Subiendo \(numeroElementos) elementos" : "Uploading \(numeroElementos) elements")
                .padding()
            Spacer()
            ZStack {
                Circle()
                    .stroke(lineWidth: 5.0)
                    .opacity(0.3)
                    .foregroundColor(Color.blue)
                    .frame(width: 50, height:50)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(porcent, 100)) / 100)
                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.yellow)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut)
                    .frame(width: 50, height:50)
                
                Text("\(Int(porcent)) %")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.trailing, 4)
        }
        .padding(8)
        .background(scheme == .dark ? .black : .white)
    }
}

struct ElementsCountUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        ElementsCountUploadScreen(numeroElementos: .constant(3), porcent: .constant(80), lenguaje: .constant("es"))
    }
}
