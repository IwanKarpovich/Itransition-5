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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func loggin(_ sender: Any) {
        let var1 = log.text!
        let var2 = pas.text!
        Auth.auth().signIn(withEmail: log.text!, password: pas.text!) { [self]
            (result, error) in
            if error != nil { print(" Andrei")
              //  ErrorLabel.alpha = 1
               // self.ErrorLabel.text = ("Error")
            } else {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy.HH.mm.ss"
                let signIn = formatter.string(from: date)
                let settings = FirestoreSettings()
                Firestore.firestore().settings = settings
                let db = Firestore.firestore()
                
                db.collection("users").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
                }
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
               // ErrorLabel.alpha = 0
                //self.ErrorLabel.text = ("Nice")
                let viewController = storyboard?.instantiateViewController(withIdentifier: "menu") as! UIViewController
                self.present(viewController, animated: true)
            }
            print(" aff ")
            
        }
        

    }
    
        
    
    
}
