//
//  Page2ViewController.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import UIKit

import Firebase



class UsersListViewController: UIViewController {
    
    let cellId = "mailCell"
    var users: [User] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUsers()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UINib(nibName: "MailTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
    }
    func getUsers () -> Void {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let email = document.get("email") as! String
                    let firstName = document.get("firstName") as! String
                    let lastName = document.get("lastName") as! String
                    let createdAt = document.get("createdAt") as! String
                    let lastLoginTime = document.get("lastLoginTime") as! String
                    let status = document.get("status") as! String
                    let databaseId = document.documentID
                    let authId = document.get("authId") as! String
                    let newUser: User = User(firstName: firstName, lastName: lastName, email: email, created: createdAt, loginTime: lastLoginTime, status: status, databaseId: databaseId, authId: authId)
                    self.users.append(newUser)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        
        let buttonText =  users[indexPath.row].status == "unblock" ? "block" : "unblock"
        let currenStatus = users[indexPath.row].status
        let greenSwipe = UIContextualAction(style: .normal, title: buttonText) {
            (action, view ,success) in
            self.blockUser(index: indexPath, currentStatus: currenStatus)
            let newStatus = currenStatus == "unblock" ? "block" : "unblock"
            self.users[indexPath.row].status = newStatus
            tableView.reloadRows(at: [indexPath], with: .automatic )
            
        }
        greenSwipe.backgroundColor = UIColor.green
        
        let swipeDelete = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view ,success) in
            self.tableView.performBatchUpdates({
                self.removeUser(index: indexPath)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: {(result) in success(true)})
        }
        
        let configure = UISwipeActionsConfiguration(actions: [swipeDelete,greenSwipe])
        configure.performsFirstActionWithFullSwipe = false
        return configure
    }
    
    func removeUser(index:IndexPath) {
        
        let indexRow = index.row
        let databaseId = users[index.row].databaseId
        let authId = users[index.row].authId
        
        users.remove(at: indexRow)
        
        db.collection("users").document(databaseId).delete() { err in
            
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            
            
        }
        if AuthModel.userAuthID == authId {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "auth")
            self.present(viewController!, animated: true)}
        
    }
    
    func blockUser(index:IndexPath, currentStatus:String) {
        
        let databaseId = users[index.row].databaseId
        let authId = users[index.row].authId

        var newStatus: String
        if currentStatus == "unblock" {
            newStatus = "block"
        }
        else {
            newStatus = "unblock"
        }
        let updateDocument = self.db.collection("users").document(databaseId)
        updateDocument.updateData([
            "status" : newStatus
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        if AuthModel.userAuthID == authId {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "auth")
            self.present(viewController!, animated: true)}
        
    }
    
}



extension UsersListViewController: UITableViewDelegate {
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension UsersListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return users.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MailTableViewCell
        cell.Nameuser.text = users[indexPath.row].firstName + users[indexPath.row].lastName
        cell.Statususer.text = users[indexPath.row].status
        cell.Textuser.text = users[indexPath.row].email
        
        return cell
    }
}
