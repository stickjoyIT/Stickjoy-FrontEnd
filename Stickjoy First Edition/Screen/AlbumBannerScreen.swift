//
//  AlbumBannerScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 08/11/23.
//

import SwiftUI

struct AlbumBannerScreen: View {
    @State var indexP = 10
        var body: some View {
            VStack {
                ScrollView {
                    ForEach(1...10, id: \.self) { i in
                        if i % 4 == 0 && i > 1  {
                            GeometryReader {
                                let size = $0.size
                                Color.red.frame(width: size.width, height: size.height)
                                    .cornerRadius(8)
                            }.frame(height:100)
                        } else {
                            HStack {
                                ForEach(0...2, id: \.self) { i in
                                    GeometryReader {
                                        let size = $0.size
                                        Color.green.frame(width: size.width, height: size.height).cornerRadius(8)
                                    }.frame(height:100)
                                }
                            }
                        }
                        
                    }
                    
                }.onAppear {
                    print("aparece")
            }
            }.padding()
        }
}

struct AlbumBannerScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumBannerScreen()
    }
}
