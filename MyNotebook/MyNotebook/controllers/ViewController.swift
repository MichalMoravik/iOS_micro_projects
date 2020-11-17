//
//  ViewController.swift
//  MyNotebook
//
//  Created by Michal Moravík on 19/02/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var noteTextView : UITextView!
    var model: Model = Model.sharedModel //singleton reference
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   /* color */
    @IBAction func backgroundSegmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            view.backgroundColor = .white
            noteTextView.backgroundColor = .white
            noteTextView.textColor = .black
            
        case 1:
            view.backgroundColor = .black
            noteTextView.backgroundColor = .black
            noteTextView.textColor = .white
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for selectedNote in model.list_notes {
            if (selectedNote.id == model.selectedDocumentID){
                 noteTextView.text = selectedNote.text
                navigationItem.title = String(selectedNote.text.prefix(30))
            }
        }
        view.backgroundColor = .white
        noteTextView.backgroundColor = .white
        noteTextView.textColor = .black
    }
    
    
    //if back button is pressed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for selectedNote in model.list_notes {
            if (selectedNote.id == model.selectedDocumentID){
                selectedNote.text = noteTextView.text // change the text of selectedNote object
                model.updateNoteInDatabase(documentID: selectedNote.id, documentTextField: selectedNote.text) // update -> override in DB
            }
        }
        model.selectedDocumentID = "" //reset the ID field
    }

    
}

