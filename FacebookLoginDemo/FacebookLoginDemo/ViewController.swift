//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Michal Moravík on 23/04/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
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
        let request = GraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, picture.type(large)"], accessToken: token, httpMethod: .GET, apiVersion: .defaultVersion)
        
        connection.add(request){ response, result in
            print("response: \(response.debugDescription)")
            switch result {
            case .success(response: let response):
                if let email = response.dictionaryValue!["email"]{
                    print("email: \(email)")
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

