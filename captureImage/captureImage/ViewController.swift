//
//  ViewController.swift
//  captureImage
//
//  Created by Michal Moravík on 05/03/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var addTextTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    @IBAction func caputrePressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image.resizeImage(newWidth: 150)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMailPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.delegate = self
            mailVC.setToRecipients(["michal.moravik@icloud.com"])
            mailVC.setSubject("testy")
            mailVC.setMessageBody("testy ... ", isHTML: false)
            let image = imageView.image?.resizeImage(newWidth: 200)
            
            
            if let imageD = image?.pngData(){
                let imageData = imageD as NSData
                 mailVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "i.png")
            }
            self.present(mailVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTextPressed(_ sender: Any) {
        drawText(textFromTextField: addTextTextField.text!)
    }
    
    
    func drawText(textFromTextField: String) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: imageView.bounds)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 50.0),
            .foregroundColor : UIColor.blue
        ]
        
        let string = NSAttributedString(string: textFromTextField, attributes: attributes)
        string.draw(at: CGPoint(x: 20, y: imageView.bounds.height/2))
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let newHeight = newWidth * (self.size.height / self.size.width)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}



