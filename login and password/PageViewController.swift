//
//  PageViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 19.12.21.
//

import UIKit
import Firebase


class PageViewController: UIViewController {
    
    var artiklerArray: [String] = []
    
    let idCell = "mailCell"
    let db = Firestore.firestore()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.dataSource = self
       
        //loadData()
        print("massiv")
        print(artiklerArray)
        
    }
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//        //let docRef = db.collection("users").//.document("users")
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if let user = user {
//                // The user's ID, unique to the Firebase project.
//                // Do NOT use this value to authenticate with your backend server,
//                // if you have one. Use getTokenWithCompletion:completion: instead.
//                let uid = user.uid
//                let created = user.metadata.creationDate
//                let signed = user.metadata.lastSignInDate
//                let email = user.email
//                let photoURL = user.photoURL
//                var multiFactorString = "MultiFactor: "
//                for info in user.multiFactor.enrolledFactors {
//                    multiFactorString += info.displayName ?? "[DispayName]"
//                    multiFactorString += " "
//                }
//                // ...
//            }
//
//        }
//

//
//
//        }
//
//
    
    
    
    //    @IBOutlet weak var table: UITableView! {
    //
    //    }
    
//    func loadData() {
//        db.collection("users").getDocuments() { (QuerySnapshot, err) in
//            if let err = err {
//                print("Error getting documents : \(err)")
//            }
//            else {
//                for document in QuerySnapshot!.documents {
//                    let documentID = document.documentID
//                    let artiklerImageView = document.get("last") as! String
//                    let artiklerTitleLabel = document.get("firstname") as! String
//
//                }
//
//                self.tableView.reloadData()
//
//            }
//        }
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           print("Tableview setup \(artiklerArray.count)")
//           return artiklerArray.count
//       }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtiklerCell", for: indexPath) as! ArtiklerCell
//        let artikler = artiklerArray[indexPath.row]
//        cell.artiklerTitleLabel.text = artikler
//        return cell
//    }


    
}


extension PageViewController: UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: idCell)
            if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idCell)
            }
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let mail = document.get("last") as! String
                        cell!.textLabel?.text = mail
                        self.artiklerArray.append(mail)
                        //print("")
                        //print("massiv")
                        print(self.artiklerArray)
                        
                    }
                    //self.tableView.reloadData()
                }
            }
           // cell!.textLabel?.text = "Mail Subjeckt"

            return cell!
        }
        
    }
