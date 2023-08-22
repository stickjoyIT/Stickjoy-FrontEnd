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
    @State private var selectedTab: Tab = .profile
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileScreen()
                .tag(Tab.profile)
                .tabItem() {
                    Image(systemName: "person")
                    Text("Profile")
                }
            
            FeedScreen()
                .tag(Tab.feed)
                .tabItem() {
                    Image(systemName: "house")
                    Text("Feed")
                }
            
            CreateUploadScreen()
                .tag(Tab.create)
                .tabItem() {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
            
            SettingsScreen()
                .tag(Tab.settings)
                .tabItem() {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
            FriendsScreen()
                .tag(Tab.friends)
                .tabItem() {
                    Image(systemName: "person.2")
                    Text("Friends")
                }
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
