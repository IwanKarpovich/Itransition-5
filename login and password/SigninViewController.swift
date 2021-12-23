//
//  SigninViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 19.12.21.
//

import UIKit
import FirebaseAuth
import Firebase

class SigninViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordtextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
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
            passwordtextField.text == nil{
            
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
                    self.errorLabel.text = "\(error?.localizedDescription)"
                } else {
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
                    let created = formatter.string(from: date)
                    let loginTime = created
                    Singleton.userAuthID = result!.user.uid
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "firstname": self.firstNameTextField.text!,
                        "last": self.lastNameTextField.text!,
                        "uid": Singleton.userAuthID,
                        
                        "created": created,
                        "loginTime": loginTime,
                        "email": self.emailTextField.text!,
                        "status": "unblock"
                        
                    ]) { (error) in
                        if error != nil {
                            fatalError("Error saving")
                        }
                    }
                    db.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "menu") as! UIViewController
                    self.present(viewController, animated: true)
                    
                    
                }
            }
        }
        
    }
    
    
    
}
