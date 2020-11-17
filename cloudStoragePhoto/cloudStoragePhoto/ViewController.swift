//
//  ViewController.swift
//  cloudStoragePhoto
//
//  Created by Michal Moravík on 05/04/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import FirebaseStorage
import FacebookLogin
import FacebookCore

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var storage : Storage?
    var storageRef : StorageReference?
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    let myimage = UIImage()
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var facebookNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image picker init
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        // storage init
        storage = Storage.storage()
        storageRef = storage!.reference()
    }
    
    @IBAction func uploadPressed(_ sender: Any, image: UIImage) {
       // let image: UIImage = imageView.image!
        uploadImage(image: imageView.image!, filename: textField.text!)
        print("successfully uploaded to firebase!")
        
    }
    
    
    @IBAction func openPressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImage(image: UIImage , filename: String){
        let data = image.jpegData(compressionQuality: 1.0)
        let imageRef = storageRef?.child(filename) //creating a new reference
        
        //if not empty call putData
        imageRef?.putData(data!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                print("failed to upload \(error.debugDescription)")
            }else {
                print("sucess in upload!")
            }
        })
    }
    
    @IBAction func facebookLoginButtonPressed(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(readPermissions: [.publicProfile], viewController: self) { (result) in
            switch result {
            case .cancelled :
                print("user cancelled the login request")
                break
            case .failed(let error):
                print("login failed because of \(error.localizedDescription)")
                break
            case .success(grantedPermissions: let granted, declinedPermissions: let declined, token: let token):
                print("Success \(token.userId.debugDescription)")
                
                //  call showUserInfo method from this controller
                self.showUserInfo(token: token)
                break
            }
        }
    }
    
    func showUserInfo(token: AccessToken) {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, picture.type(large)"], accessToken: token, httpMethod: .GET, apiVersion: .defaultVersion)
        
        connection.add(request){ response, result in
            print("response: \(response.debugDescription)")
            switch result {
            case .success(response: let response):
                if let name = response.dictionaryValue!["name"]{
                    self.facebookNameLabel.text = name as! String
                }
                
                break
            case .failed(let error):
                print("error \(error.localizedDescription)")
                break
            }
        }
        connection.start()
    }
    
}




extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


