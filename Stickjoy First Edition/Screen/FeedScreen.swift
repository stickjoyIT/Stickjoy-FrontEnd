//
//  FeedScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//  Nombre en Lista de Requerimientos: 12. Pantalla de Feed
//  Paulo:
//  ¿Qué falta?: Conectar botón de Instagram, de ir al álbum, falta variante nuevo poner una condición. 

import SwiftUI

struct FeedScreen: View {
    @State private var feedHeaderHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Add the horizontal grid of AnchoredProfileView
                        LazyVStack(spacing: 64) {
                            ForEach(feediteminfo) { feeditem in
                                //Aquí tiene que ir diferente para que traiga la información del file FeedItem
                                FeedItem(/*Aquí va: feediteminfo: feeditem*/)
                            }
                        }
                        .padding(.top, 150)
                    }
                }
                .ignoresSafeArea(.all, edges: .top) // Ignore safe area from the top
                
                FeedHeader()
                    .background(GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                feedHeaderHeight = geometry.size.height
                            }
                    })
                    .frame(height: feedHeaderHeight)
            }
            .padding(.top, 32)
        }
    }
}

struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen()
    }
}
