//
//  Note.swift
//  MyNotebook
//
//  Created by Michal Moravík on 06/04/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation

class Note {
    var id: String
    var text: String
    
    init(id: String, text:String) {
        self.id = id
        self.text = text
    }
}
