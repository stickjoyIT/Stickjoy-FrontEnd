//
//  MainTabbedView.swift
//  Stickjoy First Edition
//
//  Created by admin on 22/08/23.
//

import SwiftUI

enum TabbedItems: Int, CaseIterable {
    case profile = 0
    case feed
    case new
    case settings
    case friends
    
    var title: String{
        switch self {
        case .profile:
            return "Perfil"
        case .feed:
            return "Feed"
        case .new:
            return "Nuevo álbum"
        case .settings:
            return "Configuracion"
        case .friends:
            return "Amigos"
        }
    }
    
    var iconName: String{
        switch self {
        case .profile:
            return "person"
        case .feed:
            return "house"
        case .new:
            return "plus.circle.fill"
        case .settings:
            return "gear"
        case .friends:
            return "person.2"
        }
    }
}

@available(iOS 16.0, *)
struct MainTabbedView: View {
    @State var selectedTab = 0
    @Binding var logueado:Bool
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab){
                //ProfileScreen(logueado: $logueado, lenguaje: .constant("es"), proceso: .constant(false))
                  //  .tag(0)
                
                FeedScreen(lenguaje: .constant("es"), logueado: $logueado)
                    .tag(1)
                
                //NewAlbumScreen(avm: AlbumViewModel(), uvm: UsuariosViewModel(), isEdit: .constant(false), editor: .constant(false), nameAlbum: .constant(""), descripAlbum: .constant(""), id_albumSelected: .constant(""), imgPortadaBind: .constant("") , pickturesList: .constant([]), lenguaje: .constant(""), privacy: .constant(0), proceso: .constant(false), userOwner: "")
                    //.tag(2)
                
                SettingsScreen(logueado: $logueado, lenguaje: .constant("es"))
                    .tag(3)
                
                FriendsScreen(lenguaje: .constant("es"))
                    .tag(4)
            }
            
            ZStack {
                HStack {
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button {
                            selectedTab = item.rawValue
                        } label: {
                            
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.gray.opacity(0.6))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

@available(iOS 16.0, *)
struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView(logueado: .constant(false))
    }
}

@available(iOS 16.0, *)
extension MainTabbedView {
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
        .frame(width: isActive ? 60 : 60, height: 60)
        .background(isActive ? .gray.opacity(0.8) : .clear)
        .cornerRadius(30)
    }
}
