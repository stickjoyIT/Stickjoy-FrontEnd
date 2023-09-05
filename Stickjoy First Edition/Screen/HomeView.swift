//
//  HomeView.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import SwiftUI

struct HomeView: View {
    @State var logueado = false
    @State var lenguje = "es"
    var body: some View {
        return Group {
            if logueado {
                ContentView(logueado: self.$logueado, lenguaje: $lenguje)
            } else {
                LaunchScreen(logueado: self.$logueado, lenguaje: $lenguje)
            }
        }.onAppear{
            if UserDefaults.standard.bool(forKey: "login") {
                self.logueado = true
            }
            if let leng = UserDefaults.standard.string(forKey: "lenguaje") {
                self.lenguje = leng
            } else {
                self.lenguje = "es"
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
