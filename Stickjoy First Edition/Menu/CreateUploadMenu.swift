//
//  CreateUploadMenu.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

struct CreateUploadMenu: View {
    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Create Upload Menu"),
            buttons: [
                .default(Text("Upload Photo or Video"), action: {
                    // Implement the action for uploading photo or video
                }),
                .default(Text("Create Album"), action: {
                    // Implement the action to present NewAlbumScreen
                }),
                .cancel(Text("Cancel"))
            ]
        )
    }

    var body: some View {
        EmptyView() // This view is not meant to be directly displayed
            .actionSheet(isPresented: .constant(true), content: {
                actionSheet
            })
    }
}

struct CreateUploadMenu_Previews: PreviewProvider {
    static var previews: some View {
        CreateUploadMenu()
    }
}
