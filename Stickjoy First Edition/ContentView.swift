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

struct ContentView: View {
    @State var selectedTab = 0
    @Binding var logueado:Bool
    @Binding var lenguaje:String
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab){
                ProfileScreen(lenguaje: $lenguaje)
                    .tag(0)
                    .tabItem {
                        Label("", systemImage: "person")
                    }
                
                FeedScreen(lenguaje: $lenguaje)
                    .tag(1)
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                
                CreateUploadScreen(lenguaje: $lenguaje)
                    .tag(2)
                    .tabItem {
                        Label("", systemImage: "plus.circle.fill")
                    }
                
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
            }
            
            /*ZStack {
                HStack {
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button {
                            selectedTab = item.rawValue
                        } label: {
                            
                            //CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                            UITabBarItem(title: "", image: <#T##UIImage?#>, tag: <#T##Int#>)
                        }
                    }
                }
                .padding(6)
            }*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(logueado: .constant(false), lenguaje: .constant("es"))
    }
}

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
