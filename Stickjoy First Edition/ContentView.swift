//
//  ContentView.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//  Content View se supone que es la que abre, debería ser Launch Screen
//  Paulo: Esta pantalla es una prueba de como se verían los tabView, sin embargo, al parecer no hay tabviews que sean condicionales, es decir, que si estoy en una pantalla cambian los elementos.

import SwiftUI



enum Tab: String, CaseIterable {
    case profile
    case feed
    case create
    case settings
    case friends
}

@available(iOS 16.0, *)
struct ContentView: View {
    @State var selectedTab = 0
    @Binding var logueado:Bool
    @Binding var proceso:Bool
    @Binding var lenguaje:String
    @Binding var porcent:Float
    @State var badge = 0
    @State var badge_p = 0
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab){
                ProfileScreen(logueado:$logueado, lenguaje: $lenguaje, proceso: $proceso, porcentaje: $porcent)
                    .tag(0)
                    .tabItem {
                        Label("", systemImage: "person")
                    }
                    //.environmentObject(stm)
                
                FeedScreen(lenguaje: $lenguaje, logueado: $logueado)
                    .tag(1)
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                //SharedScreen()
                CreateUploadScreen(/*stm: stm*/lenguaje: $lenguaje, proceso: $proceso, porcentaje: $porcent)
                    .tag(2)
                    .tabItem {
                        Label("", systemImage: "plus.circle.fill")
                    }
                    .badge(badge_p)
                    //.environmentObject(stm)
                
                SettingsScreen(logueado: $logueado, lenguaje: $lenguaje)
                    .tag(3)
                    .tabItem {
                        Label("", systemImage: "gear")
                    }
                
                FriendsScreen(lenguaje:$lenguaje)
                    .tag(4)
                    .tabItem {
                        Label("", systemImage: "person.2")
                    }
                    .badge(badge)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PushNotificationTapped"))) { notification in
                // Cambia el tab cuando se toca la notificación
                if let tabNumber = notification.userInfo?["tabNumber"] as? Int {
                    if tabNumber == 4 {
                        self.selectedTab = tabNumber
                        badge = 1
                    } else {
                       // badge_p = 1
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
extension ContentView {
    func CustomTabItem(imageName:String, title:String, isActive:Bool) -> some View {
        HStack(spacing: 10){
            Spacer()
            Image(systemName:imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .yellow : .gray)
                .frame(width: 20, height: 20)
            Spacer()
        }
        .frame(width: isActive ? 50 : 40, height: 50)
        .background(isActive ? .gray.opacity(0.8) : .clear)
        .cornerRadius(30)
    }
}
