//
//  ViewController.swift
//  Users
//
//  Created by Robert Oganiani on 6/21/18.
//  Copyright © 2018 Robert Oganiani. All rights reserved.
//

import UIKit
import CoreData

class UsersController: UITableViewController, CreateUserControllerDelegate {
    func didEditUser(user: User) {
        let row = users.index(of: user)
        let reloadIndexPath = IndexPath(row: row! , section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .fade)
    }
    
    func didAddUser(user: User) {
        users.insert(user, at: 0)
        
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    var users = [User]()
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandler)
        deleteAction.backgroundColor = UIColor.orange
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandler)
        editAction.backgroundColor = UIColor.purple
        
        return [deleteAction, editAction]
    }
    
    private func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        
        self.users.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(user)
        
        do {
            try context.save()
        } catch let saveErr {
            print("Error deleting user", saveErr)
        }
    }
    
    private func editHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let editUserController = CreateUserController()
        editUserController.delegate = self
        editUserController.user = users[indexPath.row]
        
        let navController = CustomNavigationController(rootViewController: editUserController)
        present(navController, animated: true, completion: nil)
    }
    
    private func fetchUsers() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let users = try context.fetch(fetchRequest)
            
            self.users = users.reversed()
            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch users", fetchErr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Users"
        
        tableView.backgroundColor = .tableBgColor
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddUser))
        
    }  
    
    @objc func handleAddUser() {
        let createUserController = CreateUserController()
        
        let navController = CustomNavigationController(rootViewController: createUserController)
        
        createUserController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .headerBgColor
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let user = users[indexPath.row]
        if let name = user.name, let birthdate = user.birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let formattedBirthdate = dateFormatter.string(from: birthdate)
            
            cell.textLabel?.text = "\(name) - Birthday \(formattedBirthdate )"
        } else {
            cell.textLabel?.text = user.name
        }
        
        cell.backgroundColor = .cellBgColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

