 //
 //  CreateUserController.swift
 //  Users
 //
 //  Created by Robert Oganiani on 6/22/18.
 //  Copyright © 2018 Robert Oganiani. All rights reserved.
 //
 
 import UIKit
 import CoreData
 
 protocol CreateUserControllerDelegate {
    func didAddUser(user: User)
 }
 
 class CreateUserController: UIViewController {
    var delegate: CreateUserControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        // enable auto layout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.tableBgColor
        
        setupUI()
        
        navigationItem.title = "Create User"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    private func setupUI() {
        let backgroundView = UIView()
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.headerBgColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
    }
    
    @objc func handleSave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        user.setValue(nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddUser(user: user as! User)
            })
        } catch let saveErr {
            print("Failed to save user", saveErr)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
 }
