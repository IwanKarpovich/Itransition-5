//
//  Page2ViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import UIKit

import Firebase



class Page2ViewController: UIViewController {
    
    let idCell = "mailCell"
    let names = ["sdfdsf", "asdfdsf", "gfg"]
    let db = Firestore.firestore()
    var artiklerArray: [String] = []
    var userAuthIds: [String] = []
    var userStatuses: [String] = []
    var massiv: [String] = []
    var userDatabaseIds: [String] = []
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        
        massiv = mas()
        
        print("TAble")
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //tableView.isEditing = true
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "MailTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
    }
    func mas () -> [String]
    {
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
                    //cell!.textLabel?.text = mail
                    self.artiklerArray.append(mail)
                    //print("")
                    //print("massiv")
                    print(self.artiklerArray)
                    print("")
                    let nam = document.get("uid") as! String
                    //cell!.textLabel?.text = mail
                    self.userAuthIds.append(nam)
                    //print("")
                    //print("massiv")
                    print(self.userAuthIds)
                    let sos = document.get("status") as! String
                    //cell!.textLabel?.text = mail
                    self.userStatuses.append(sos)
                    //print("")
                    //print("massiv")
                    print(self.userStatuses)
                    
                    let numberid = document.documentID as! String
                    //cell!.textLabel?.text = mail
                    self.userDatabaseIds.append(numberid)
                    //print("")
                    //print("massiv")
                    print(self.userDatabaseIds)
                }
                self.tableView.reloadData()
            }
        }
        return artiklerArray
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        //        let swipeRead = UIContextualAction(style: .normal, title: "Block") {
        //            (action, view ,success) in print("No read Swipe")
        //        }
        let buttonText =  userStatuses[indexPath.row] == "unblock" ? "block" : "unblock"
        let currenStatus = userStatuses[indexPath.row]
        let swipeGreen = UIContextualAction(style: .normal, title: buttonText) {
            
            (action, view ,success) in
            self.blockUser(index: indexPath, currentStatus: currenStatus)
            var newStatus = currenStatus == "unblock" ? "block" : "unblock"
            self.userStatuses[indexPath.row] = newStatus
            print("No read Swipe")
            tableView.reloadRows(at: [indexPath], with: .automatic )
            
            
        }
        
        
        
        swipeGreen.backgroundColor = UIColor.green
        
        
        let swipeblue = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view ,success) in
            print("No read Swipe")
            self.tableView.performBatchUpdates({
                self.removeMessage(index: indexPath)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
                                               , completion: {(result) in success(true)})
        }
        
        let configure = UISwipeActionsConfiguration(actions: [swipeblue,swipeGreen])
        
        configure.performsFirstActionWithFullSwipe = false
        return configure
    }
    
    func removeMessage(index:IndexPath) {
        print(userDatabaseIds)
        var ss = index.row
        var pp = userDatabaseIds[index.row]
        var ppg = userAuthIds[index.row]
        artiklerArray.remove(at: ss)
        userAuthIds.remove(at: ss)
        userDatabaseIds.remove(at: ss)
        db.collection("users").document(pp).delete() { err in
            
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            
            
        }
        if Singleton.userAuthID == ppg {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "auth") as! UIViewController
            self.present(viewController, animated: true)}
        
    }
    
    func blockUser(index:IndexPath, currentStatus:String) {
        
        print(userDatabaseIds)
        var ss = index.row
        var pp = userDatabaseIds[index.row]
        var ppg = userAuthIds[index.row]
        //        artiklerArray.remove(at: ss)
        //        userAuthIds.remove(at: ss)
        //        userDatabaseIds.remove(at: ss)
        
        
        db.collection("users").whereField("uid", isEqualTo: ppg)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var newStatus: String
                        if currentStatus == "unblock" {
                            newStatus = "block"
                        }
                        else {
                            newStatus = "unblock"
                        }
                        let updateDocument = self.db.collection("users").document(pp)
                        updateDocument.updateData([
                            "status" : newStatus
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
            }
        
        
        if Singleton.userAuthID == ppg {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "auth") as! UIViewController
            self.present(viewController, animated: true)}
        
    }
    
}



extension Page2ViewController: UITableViewDelegate {
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
}

extension Page2ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return artiklerArray.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! MailTableViewCell
        cell.Nameuser.text = artiklerArray[indexPath.row]
        cell.Statususer.text = userAuthIds[indexPath.row]
        cell.Textuser.text = userDatabaseIds[indexPath.row]
        
        //        let ell = UITableViewCell(style: .default, reuseIdentifier: "call")
        //        // ell.textLabel?.text = artiklerArray[indexPath.row]
        //        ell.textLabel?.text = "\(artiklerArray[indexPath.row]) Section:\(uid[indexPath.row]) "
        //
        //        return ell
        
        return cell
        
        
    }
}
