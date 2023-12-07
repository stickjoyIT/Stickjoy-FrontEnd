//
//  HomeView.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import SwiftUI
import Firebase

@available(iOS 16.0, *)
struct HomeView: View {
    @State var logueado = false
    @State var procesando = false
    @State var lenguje = "es"
    @ObservedObject var uvm = UsuariosViewModel()
    @StateObject var stm = StorageManager()
    @State var listaImagenesUpload = [ElementItem]()
    @State var albumSelected = AlbumSelectView(id_album: "", name: "", descrip: "", url: "", userName: "")
    @State var porcentaje:Float = 0.0
    @State var badge_p = 0
    var body: some View {
        return Group {
            if logueado {
                ContentView(logueado: self.$logueado, proceso: self.$procesando, lenguaje: $lenguje, porcent: $porcentaje)
                    .environmentObject(stm)
            } else {
                LaunchScreen(logueado: self.$logueado, lenguaje: $lenguje)
            }
        }.onAppear{
            procesando = UserDefaults.standard.bool(forKey: "uploading")
            
            let leng = UserDefaults.standard.string(forKey: "lenguaje") ?? "No hay"
            print("lenguaje: ",leng)
            if UserDefaults.standard.bool(forKey: "login") {
                self.logueado = true
            }
            if let leng = UserDefaults.standard.string(forKey: "lenguaje") {
                self.lenguje = leng
                print("lenguaje existe: ",leng)
            } else {
                self.lenguje = "es"
                print("lenguaje no existe: ",leng)
                UserDefaults.standard.set("es",forKey: "lenguaje")
            }
        }
    }
}

@available(iOS 16.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
