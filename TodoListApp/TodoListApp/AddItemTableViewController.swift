//
//  AddItemTableViewController.swift
//  TodoListApp
//
//  Created by User on 7/7/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

protocol AddItemTableViewControllerDelegate: class {
    //the protocol can be implemented only in classes
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) //needs for callint Additemveiwcontroller
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) //the main purpose of this protocol to give the access for other classes for checklist item, i e to get this value back
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem, flag: Bool)
      func addItemViewController(_ controller: AddItemTableViewController, didFinishDeleting item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController {
    
    weak var delegate: AddItemTableViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    weak var itemToDelete: ChecklistItem?
    let default1 = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "Edit Item"
            text.text = item.text
            done.isEnabled = true
        }
         navigationItem.largeTitleDisplayMode = .never 
    }

    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var delete: UIBarButtonItem!
    @IBOutlet weak var text: UITextField!
    
    
    @IBAction func cancelAc(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    @IBAction func deleteAc(_ sender: Any) {
        if let item = itemToEdit{
            let flag = true
            delegate?.addItemViewController(self, didFinishEditing: item, flag: flag)
        }
    }
    @IBAction func doneAc(_ sender: Any) {
        if let item = itemToEdit, let text = text.text{
            item.text = text
            let flag = false //the point for saving data to UserDefaults
            delegate?.addItemViewController(self, didFinishEditing: item, flag: flag)
        }else{
            if let item = todoList?.newTodo(){
                if let textFieldText = text.text{
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.addItemViewController(self, didFinishAdding: item)
                storeTheData(item: item)
            }
        }
    }
    
    func storeTheData(item: ChecklistItem){
        todoList?.userDefaultsArray.append(item.text)
        default1.set(todoList?.userDefaultsArray, forKey: "items")
    }
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
      text.becomeFirstResponder() //the func for poping up the keyboard and making the textfield first responder
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil // this func give us an opportunity to determine if the row can be selected or not
    }
    
}


extension AddItemTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      text.resignFirstResponder() //the func for dissmising the keyboard after finishing typing the message i e that keyboard will go away
      return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //the method used for kind of the manupating what the user types into the textfield, we get the information what the user types in
      
      guard let oldText = text.text, //the current text which was't changed
            let stringRange = Range(range, in: oldText) else { //range means the all chars in the textfield
          return false
      }
      
      let newText = oldText.replacingCharacters(in: stringRange, with: string) // get all data what the user pasted into textfield
      if newText.isEmpty { //checking if the textfield is empty or not
        done.isEnabled = false
      } else {
        done.isEnabled = true
      }
      return true
    }
}
