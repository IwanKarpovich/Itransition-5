//
//  LoginViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 19.12.21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self]
            (result, error) in
            if error != nil{ print(" Andrei")
                ErrorLabel.alpha = 1
                self.ErrorLabel.text = ("Error")
            } else {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
                let signIn = formatter.string(from: date)
                let settings = FirestoreSettings()
                Firestore.firestore().settings = settings
                let db = Firestore.firestore()
//                let mas = result!.user.uid
//                //let washingtonRef = db.collection("users").document(result?.user.providerID ?? "")
//                db.collection("users")//.whereField("uid", isEqualTo: result!.user.uid)
//                    .getDocuments() { (querySnapshot, err) in
//                        if let err = err {
//                            print("Error getting documents: \(err)")
//                        } else {
//                            for document in querySnapshot!.documents {
//                                print("\(document.documentID) => \(document.data())")
//                            }
//                        }
//                }
                
                // Set the "capital" field of the city 'DC'
//                washingtonRef.updateData([
//                    "loginTime" : signIn
//                ]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        print("Document successfully updated")
//                    }
//                }
                
                print("next")
                ErrorLabel.alpha = 0
                self.ErrorLabel.text = ("Nice")
                let viewController = storyboard?.instantiateViewController(withIdentifier: "menu") as! UIViewController
                self.present(viewController, animated: true)
            }
            print(" aff ")
            
        }
        

    }
    
   
}
