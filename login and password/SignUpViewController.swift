//
//  SigninViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 19.12.21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    func checkValid() -> String? {
        if firstNameTextField.text == "" ||
            lastNameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordtextField.text == "" ||
            firstNameTextField.text == nil ||
            lastNameTextField.text == nil ||
            emailTextField.text == nil ||
            passwordtextField.text == nil {
            
            return "Please fill in all fiels"
        }
        return nil
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let error = checkValid()
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordtextField.text!) { (result, error) in
                if error != nil {
                    self.errorLabel.text = "\(String(describing: error?.localizedDescription))"
                } else {
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
                    let createdAt = formatter.string(from: date)
                    let loginTime = createdAt
                    AuthModel.userAuthID = result!.user.uid
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "firstName": self.firstNameTextField.text!,
                        "lastName": self.lastNameTextField.text!,
                        "authId": AuthModel.userAuthID,
                        "createdAt": createdAt,
                        "lastLoginTime": loginTime,
                        "email": self.emailTextField.text!,
                        "status": "unblock"
                    ]) { (error) in
                        if error != nil {
                            fatalError("Error saving")
                        }
                    }
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "menu")
                    self.present(viewController!, animated: true)
                }
            }
        }
    }
}
