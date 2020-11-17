//
//  TableViewController.swift
//  MyNotebook
//
//  Created by Michal Moravík on 19/02/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    var model: Model = Model.sharedModel //singleton reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completionHandler()
        
       // self.tableView.register(NoteCell.self, forCellReuseIdentifier: "myCustomNoteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        completionHandler()
    }
    
    // because addSnapshotListener in Model is asycn and I need to wait for completion of the array
    func completionHandler() {
        model.getDataFromDatabase { (list_notes) in
            self.model.list_notes = list_notes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // showing the same amount of rows as array of notes has
    // returns integer
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.list_notes.count
    }

    // returns UITableViewCell (cell object)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCustomNoteCell") as! NoteCell
        
        cell.noteTextLabel.text = self.model.list_notes[indexPath.row].text
        
        return cell
    }
    
    // adding a new note after clicking on + button
    @IBAction func newNote() {
        model.saveNewNoteWithGeneratedIDToDatabase(noteText: "New Note")
        self.tableView.reloadData()
        completionHandler() // again take data from database
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "view1") {
            if  let _:ViewController = segue.destination as? ViewController {
                let selectedIndex = self.tableView.indexPathForSelectedRow?.row ?? -1 // get selected index in tableview
               
                // get the ID of the object from the array on selected index
                model.selectedDocumentID = model.list_notes[selectedIndex].id
                print("selected id after prepare method " + String(model.selectedDocumentID) )
            }
        }
    }
    

    
    // -------------------------------------------- //
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    
 

}
