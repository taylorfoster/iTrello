//
//  Card.swift
//  iTrello
//
//  Created by Taylor Foster on 11/2/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import Foundation

class Card {
    
    var title: String
    var id: String
    var desc: String
    
    init(title: String, id: String, desc: String) {
        self.title = title
        self.id = id
        self.desc = desc
    }

}