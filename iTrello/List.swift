//
//  List.swift
//  iTrello
//
//  Created by Taylor Foster on 11/2/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import Foundation

class List {
    
    var title: String
    var id: String
    var arrayofCards: [Card]
    
    init(title: String, id: String) {
        self.title = title
        self.id = id
        self.arrayofCards = [Card]()
    }

}