//
//  Spotlight.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-10-30.
//  Purpose:
//         Handles spotlight indexing

// MARK: Imports

import CoreSpotlight
import UIKit

// MARK: Types

struct Spotlight{
   
    // MARK: Spotlight Functions
    
    /// Spotlight Indexing
    /// index binders and decks
    static func indexData(id: String, name: String, image: UIImage?, description: String){
        var attributeSet: CSSearchableItemAttributeSet{
            let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
            attributeSet.title = name
            attributeSet.contentDescription = description
            attributeSet.keywords = ["Deck", "Binder", "Collection", "Cards", "Magic", "Magic The Gathering", name, description]
            
            return attributeSet
        }
        
        let item = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "mtgcollector", attributeSet: attributeSet)
        
        CSSearchableIndex.default().indexSearchableItems([item]) { _ in }
        
    }
    
    /// MARK: Handle Spotlight
//    static func handleSpotlight(userActivity: NSUserActivity, index: inout String)  {
//        guard let searched = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
//            return
//        }
//        
//        print(searched)
//        index = searched
//    }
}
