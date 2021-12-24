//
//  login2ViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loggin(_ sender: Any) {
        Auth.auth().signIn(withEmail: login.text!, password: password.text!) { [self]
            (result, error) in
            if error != nil {
                ErrorLabel.alpha = 1
                self.ErrorLabel.text = ("Error")
            } else {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
                let signInTimestamp = formatter.string(from: date)
                let settings = FirestoreSettings()
                Firestore.firestore().settings = settings
                let db = Firestore.firestore()

                db.collection("users").whereField("authId", isEqualTo: result!.user.uid)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                AuthModel.userAuthID =  document.get("authId") as! String
                                
                                let userDocument = db.collection("users").document(document.documentID)
                                userDocument.updateData([
                                    "lastLoginTime" : signInTimestamp
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                
                                ErrorLabel.alpha = 1
                                self.ErrorLabel.text = ("Nice")
                                if document.get("status") as! String == ("unblock") {
                                    let viewController = storyboard?.instantiateViewController(withIdentifier: "menu")
                                    self.present(viewController!, animated: true)
                                    self.ErrorLabel.text = ("Nice")
                                }
                                self.ErrorLabel.text = ("You are blocked")
                            }
                        }
                    }
            }
        }
    }
}
