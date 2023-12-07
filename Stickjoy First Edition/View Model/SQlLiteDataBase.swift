//
//  SQlLiteDataBase.swift
//  Stickjoy First Edition
//
//  Created by admin on 29/11/23.
//

import SwiftUI
import SQLite

class DataBase : ObservableObject {
    
    func createTable(name:String) {
        
        do {
            let db = try Connection("path/to/db.sqlite3")
            
            let users = Table(name)
            let id = Expression<String>("id")
            let name = Expression<String?>("url")
            let alto = Expression<String>("alto")
            let ancho = Expression<String>("ancho")
            let descrip = Expression<String>("descrip")
            let tipo = Expression<String>("tipo")
            let duration = Expression<String>("duration")
            let uploading = Expression<String>("uploading")
            let upload = Expression<String>("upload")
            let success = Expression<String>("succes")
            
            try db.run(users.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(alto)
                t.column(ancho)
                t.column(tipo)
                t.column(duration)
                t.column(descrip)
                t.column(uploading)
                t.column(upload)
                t.column(success)
            })
        } catch {
            print ("error database:", error)
        }
    }
    
    func insertTable(){
        
    }
    
}
