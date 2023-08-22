//
//  FeedHeaderInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

//Album model and Album Items

struct FeedHeaderInfo: Identifiable {
    var id = UUID().uuidString
    var profileName: String

}

var feedheader = [
    FeedHeaderInfo(profileName: "John Smith"),
]
