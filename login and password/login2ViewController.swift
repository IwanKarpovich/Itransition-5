//
//  login2ViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import UIKit
import Firebase

class login2ViewController: UIViewController {
    
    
    @IBOutlet weak var log: UITextField!
    
    @IBOutlet weak var pas: UITextField!
    
    @IBOutlet weak var butt: UIButton!
    
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loggin(_ sender: Any) {
        let var1 = log.text!
        let var2 = pas.text!
        Auth.auth().signIn(withEmail: log.text!, password: pas.text!) { [self]
            (result, error) in
            if error != nil { print(" Andrei")
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
                
                
                let mas = result!.user.uid
                
                
                
                
                db.collection("users").whereField("uid", isEqualTo: result!.user.uid)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                Singleton.userAuthID =  document.get("uid") as! String
                                
                                print("\(document.documentID) => \(document.data())")
                                let washingtonRef = db.collection("users").document(document.documentID)
                                washingtonRef.updateData([
                                    "loginTime" : signIn
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                print("next")
                                ErrorLabel.alpha = 1
                                self.ErrorLabel.text = ("Nice")
                                if document.get("status") as! String == ("unblock")
                                {let viewController = storyboard?.instantiateViewController(withIdentifier: "menu") as! UIViewController
                                self.present(viewController, animated: true)
                                    self.ErrorLabel.text = ("Nice")
                                }
                                self.ErrorLabel.text = ("You are blocked")
                            }
                            }
            
                    }
                
                
                
                
                
            }
            print(" aff ")
            
        }
        
        
    }
    
    
    
    
}
