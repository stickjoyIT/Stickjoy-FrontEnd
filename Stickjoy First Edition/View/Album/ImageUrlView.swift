//
//  ImageUrlView.swift
//  Stickjoy First Edition
//
//  Created by admin on 04/12/23.
//


import SwiftUI

struct ImageUrlView : UIViewRepresentable {
    var url : URL
    @ObservedObject var vm: AlbumViewModel
    func makeUIView(context: Context) -> UIImageView {
        let imageU = UIImageView()
        imageU.contentMode = .scaleAspectFit
        vm.loadImage(url: url, image: { img in
            imageU.image = img
        })
        
        return imageU
    }
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
}
