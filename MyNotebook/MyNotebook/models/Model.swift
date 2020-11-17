//
//  model.swift
//  MyNotebook
//
//  Created by Michal Moravík on 20/02/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Model {
    
    static let sharedModel = Model() // Singleton
    var selectedDocumentID: String = "" // default index (-1) cannot make problems
    
    var collectionRef: CollectionReference! // reference to Firebase collection
    var documentRef: DocumentReference! // reference to Firebase document - testing purpose only
    
    var list_notes = [Note]() // consists of id and field "text"
    
    func saveNewNoteWithGeneratedIDToDatabase(noteText:String) {
        collectionRef = Firestore.firestore().collection("Notes")
        
        // unique (using add) document creation
        // text from the note will be specified by parameter
        documentRef = collectionRef.addDocument(data: [
                "text": noteText
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(self.documentRef!.documentID)")
                }
            }
    }
    
    // update note == update document simple as that... basically the same saving but this time we know an ID and the text is taken from text area
    func updateNoteInDatabase(documentID: String, documentTextField: String) {
        collectionRef = Firestore.firestore().collection("Notes")

        collectionRef.document(documentID).setData([
            "text": documentTextField
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func getDataFromDatabase(callback: @escaping([Note]) -> Void) {
        var notes: [Note] = []
        collectionRef = Firestore.firestore().collection("Notes")
    
        collectionRef.addSnapshotListener { querySnapshot, error in
            for document in querySnapshot!.documents{
                if (document.data()["text"] as? String) != nil {
                    let note = Note(id: document.documentID, text: (document.data()["text"] as? String)!)
                    notes.append(note)
                    print("got note: ", note.id, note.text)
                }
            }
            callback(notes)
        }
    }
}
