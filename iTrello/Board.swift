//
//  File.swift
//  iTrello
//
//  Created by Taylor Foster on 10/31/16.
//  Copyright © 2016 Taylor Foster. All rights reserved.
//

import UIKit


class Board {
    
    var title: String
    var id: String
    var arrayofLists: [List]

    init(title: String, id: String) {
        self.title = title
        self.id = id
        self.arrayofLists = [List]()
    }
}