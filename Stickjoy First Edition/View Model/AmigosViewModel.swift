//
//  AmigosViewModel.swift
//  Stickjoy First Edition
//
//  Created by admin on 23/08/23.
//

import Foundation

final class AmigosViewModel:ObservableObject {
    @Published var mensaje = ""
    @Published var amigosList = [Amigo]()
    
    func getAmigoList(compaation:@escaping (Bool) -> Void){
        
        let url = baseUrl + ""
        
    }
}
