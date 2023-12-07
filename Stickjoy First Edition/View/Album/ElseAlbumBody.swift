//
//  ElseAlbumBody.swift
//  Stickjoy First Edition
//
//  Created by admin on 09/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ElseAlbumBody: View {
    @Binding var editar:Bool
    @ObservedObject var avm:AlbumViewModel
    @Binding var pickturesList:[pickture]
    @State var matrizPick = [[pickture]]()
    @State var goFullSize = false
    @State var imgUrl = ""
    @State var indexScroll = 0
    @State var idImgSelected = 0
    @State var alertConfirm = false
    @State var showAlert = false
    @State var lenguaje = ""
    @State var mensaje = ""
    var body: some View {
        VStack {
            let colums2 = Array(repeating: GridItem(spacing:5), count: 1)
            LazyVGrid(columns: colums2, alignment: .center ,content: {
                ForEach(Array(avm.matrizPick.enumerated()), id: \.offset) { index, item in
                    if index % 3 == 0 && index > 1 {
                        HStack(alignment:.center) {
                            GeometryReader {
                                let size = $0.size
                                BannerAlbumViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716", ancho: size.width, alto: 50)
                            }
                        }
                        .frame(height:50)
                    }
                    let colums3 = Array(repeating: GridItem(spacing:10), count: 3)
                    LazyVGrid(columns: colums3, content: {
                        ForEach(Array(item.enumerated()), id:\.offset) { indexI, list in
                            GeometryReader {
                                let sizeIm = $0.size
                                ZStack(alignment:.topTrailing) {
                                    if list.tipo == 1 {
                                        AnimatedImage(url: list.url)
                                            .indicator(SDWebImageActivityIndicator.medium)
                                            .transition(.fade)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: sizeIm.width, height: sizeIm.height)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                imgUrl = "\(list.url)"
                                                goFullSize = true
                                                getIndexList(picktures: pickturesList, id_img: list.id_img)
                                            }
                                    } else {
                                        ZStack(alignment: .bottomTrailing) {
                                            Image(uiImage: list.image)
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width:sizeIm.width, height: sizeIm.height)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    imgUrl = "\(list.url)"
                                                    goFullSize = true
                                                    getIndexList(picktures: pickturesList, id_img: list.id_img)
                                                }
                                            
                                            Text(list.duration)
                                                .padding(4)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }.frame(height: 100)
                        }
                    })
                }
            })
            if pickturesList.count % 9 == 0 && pickturesList.count > 1{
                HStack(alignment:.center) {
                    GeometryReader {
                        let size = $0.size
                        BannerAlbumViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716", ancho: size.width, alto: 50)
                    }
                }
                .frame(height:50)
            }
        }
        .padding(10)
        .onAppear {
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
        .fullScreenCover(isPresented: $goFullSize, content: {
            FullSizeItem(img: $imgUrl, name_album: .constant(""), username: .constant(""), album_descrip: .constant(""), profileImg: .constant(""), indexScroll: $indexScroll, images: .constant(pickturesList))
        })
    }
    
    func getIndexList(picktures:[pickture], id_img:String){
        let indexL = picktures.firstIndex( where: { $0.id_img == id_img })
        indexScroll = indexL ?? 0
        goFullSize = true
    }
}

