//
//  AddTableViewController.swift
//  TodoListApp
//
//  Created by User on 7/7/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

protocol AddTableViewControllerDelegate: class { //the protocol can be implemented only in classes
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) //needs for callint Additemveiwcontroller
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) //the main purpose of this protocol to give the access for other classes for checklist item, i e to get this value back
  func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem, flag: Bool)
    func addItemViewController(_ controller: AddItemTableViewController, didFinishDeleting item: ChecklistItem)
}


class AddTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    weak var delegate: AddTableViewControllerDelegate? //if the class implements protocol then it will be the delegate of additemviewcontroller
    weak var todoList: TodoList?//these are two properties, which will be used by AddItemTableViewController for receiving the data
    weak var itemToEdit: ChecklistItem?
      weak var itemToDelete: ChecklistItem?
      let default1 = UserDefaults.standard
    
    
    
    
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self) //the func for going back to the previos view controller(it is the implementation one of the methods of the protocol)
    }
    
    @IBAction func delete1(_ sender: Any) {
    }
    
    @IBAction func done(_ sender: Any) {
    }
    
    
    
    
}
