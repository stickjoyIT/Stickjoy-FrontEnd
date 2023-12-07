//
//  SuscriptionItem.swift
//  Stickjoy First Edition
//
//  Created by admin on 19/10/23.
//

import Foundation
import StoreKit

struct SuscriptionItem: Hashable {
    let id : String
    let title : String
    let description : String
    var lock : Bool
    var price : String?
    let locale : Locale
    
    lazy var formatter : NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(product: SKProduct, lock: Bool = true){
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.lock = lock
        self.locale = product.priceLocale
        if lock {
            self.price = formatter.string(from: product.price)
        }
        
    }
    
}
