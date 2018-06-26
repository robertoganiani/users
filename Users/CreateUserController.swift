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
    func didEditUser(user: User)
 }
 
 class CreateUserController: UIViewController {
    var user: User? {
        didSet {
            nameTextField.text = user?.name
            guard let birthdate = user?.birthdate else { return }
            datePicker.date = birthdate
        }
    }
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = user == nil ? "Create user" : "Edit user"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.tableBgColor
        
        setupUI()
        
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
        backgroundView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
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
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
    }
    
    @objc func handleSave() {
        user == nil ? createUser() : saveUserChanges()
    }
    
    private func createUser() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        user.setValue(nameTextField.text, forKey: "name")
        user.setValue(datePicker.date, forKey: "birthdate")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddUser(user: user as! User)
            })
        } catch let saveErr {
            print("Failed to save user", saveErr)
        }
    }
    
    private func saveUserChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        user?.name = nameTextField.text
        user?.birthdate = datePicker.date
        
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didEditUser(user: self.user!)
            }
        } catch let editErr {
            print("Error while editing", editErr)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
 }
