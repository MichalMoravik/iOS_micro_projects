//
//  NoteCell.swift
//  MyNotebook
//
//  Created by Michal Moravík on 06/04/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell {
    //var noteText: String?
    
    
    @IBOutlet weak var noteTextLabel: UILabel!
    
    
    //var noteTextView: UITextView = UITextView()
    
    /*override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(noteTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("fatal error")
    }*/
    
   /* override func layoutSubviews() {
        super.layoutSubviews()
        if let noteText = noteText {
            noteTextView.text = noteText
        }
    }*/
}
