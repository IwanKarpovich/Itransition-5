//
//  PageViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 19.12.21.
//

import UIKit
import Firebase


class PageViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        //let docRef = db.collection("users").//.document("users")
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let created = user.metadata.creationDate
                let signed = user.metadata.lastSignInDate
                let email = user.email
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                // ...
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
        
    }
    
    
    
    //    @IBOutlet weak var table: UITableView! {
    //
    //    }
    
}
