//
//  FeedItemInfo.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
//

import SwiftUI

//Album model and Album Items

struct FeedItemInfo: Identifiable {
    var id = UUID().uuidString
    var profileImage: String
    var profileName: String
    var userName: String
    var feedItem: String
    var feedItemName: String
    var feedItemDescription: String
    var feedItemTimestamp: String

}

var feediteminfo = [
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
    FeedItemInfo(profileImage: "profilePicture", profileName: "John Smith", userName: "@johnysmith", feedItem: "uploadedPicture", feedItemName: "My dog", feedItemDescription: "Celebrating on the beach", feedItemTimestamp: "2 hours ago"),
]
