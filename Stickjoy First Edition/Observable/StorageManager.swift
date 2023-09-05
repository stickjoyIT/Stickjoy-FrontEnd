//
//  StorageManager.swift
//  Stickjoy First Edition
//
//  Created by admin on 25/08/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

public class StorageManager: ObservableObject {
    let storage = Storage.storage()
    
    @Published var loading = false
    
    func upload(urls: [URL], nameAlbum:String, compation:@escaping (String) -> Void) {
        
        loading = true
        
        // Create a storage reference
        let cleanName = nameAlbum.replacingOccurrences(of: " ", with: "_")
        let storageRef = storage.reference()
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        let nameFile = id+"/"+urls.first!.lastPathComponent
        
        print(nameFile)
        
        storageRef.child(nameFile).putFile(from:urls.first!, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
                compation("")
            }
            
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
            
            // Obtén la URL de descarga de la imagen
            storageRef.child(nameFile).downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    compation("")
                    return
                }
                
                if let downloadURL = url {
                    print("Download URL: \(downloadURL)")
                    compation("\(downloadURL)")
                }
                
                self.loading = false
            }
            
        }
    }
    
    
    func listAllFiles() {
        // Create a reference
        let storageRef = storage.reference().child("images")
        
        // List all items in the images folder
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error while listing all files: ", error)
            }
            
            for item in result!.items {
                print("Item in images folder: ", item)
            }
        }
    }
    
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
