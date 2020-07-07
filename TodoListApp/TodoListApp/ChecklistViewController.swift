//
//  ChecklistViewController.swift
//  TodoListApp
//
//  Created by User on 7/7/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var todoList: TodoList
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true // integrating the navigation bar title into the app(top side of the screen)
        
    }

    required init?(coder aDecoder: NSCoder) {
      todoList = TodoList() // initilazing the model ofr using the data, the array of items
      //addItem = AddItemTableViewController()
      super.init(coder: aDecoder)
    }
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = todoList.todos.count // creating the index for appending a new element at of the end array
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // creating the indexPath where will be set the new element
        let indexPaths = [indexPath] // it needs to pass the requirement for inserting, inserting needs in the array of indexPaths
        tableView.insertRows(at: indexPaths, with: .automatic) //inserting a new item in the table view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count // Accesing the array of the tasks and count how objects inside array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) // Creating an actual cell in this method connectin with identifier from mainstoryboard for it's index path. Index path is a location of the cell(section number and row number) - address
        let item = todoList.todos[indexPath.row] //creating an item in array, which saved in model, i e getting the current task from todos array
        configureText(for: cell, with: item) // sending to method, which will turn the element of array which type is CheckListItem to String and it's position
        configureCheckmark(for: cell, with: item) // sending the item for detecting checkmark's status and it's position
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //the delegate method of the table view, the function's wich is to interact with the user taps on the cell
        if let cell = tableView.cellForRow(at: indexPath) { // indicating the cell where will be the delegations by index path
          let item = todoList.todos[indexPath.row] //indicating the item where over which will be the delegetions
          configureCheckmark(for: cell, with: item) // sending to the func for setting the status of the checkmark
          tableView.deselectRow(at: indexPath, animated: true) // the func which fix the problem with fixed selection of the cell, it will be deselected after tapping on it
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //getting the oppotrunity to swipe and delete the items from the table
        
        todoList.todos.remove(at: indexPath.row) //removing the checklist item by it's index path
        let indexPaths = [indexPath] //creating a variable to hold all the the possible indexPaths, which was updateda
        tableView.deleteRows(at: indexPaths, with: .automatic) //and then just updating the table view, but it general it is only the visual updating the table, we don't update the model
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) { //creating own method for converting the item into String and printin on the given cell
      if let label = cell.viewWithTag(1000) as? UILabel { // tag means the given identifier for the cell in table view manually, tag is set in the main storyboard
          
        label.text = item.text
          // item.text - text is the property of the CheckListItem class, used for converting the arrat item into String P.S. check out TodoList class and CheckListItem class
      }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) { // own method for setting the checkmark status, also fixing problem the recycling the cell's checkmark, don't let it randomly set the status of the checkmark. We need to use this method in two places to fix the bug with the recycling the checkmarks
      guard let checkmark = cell.viewWithTag(1001) as? UILabel else { //given identifier in the main storyboard
        return
      }
      if item.checked {
        checkmark.text = "√"
      } else {
        checkmark.text = ""
      }
      // item.checked - checked is the property of the Checklistitem class which is bool, by default it is false, also there is a func toggleChecked() for revercing the checked property
      // the if statement for switching position of the checkmark
      
      item.toggleChecked()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // the method for becoming the delegate of additemviewcontroller
          if segue.identifier == "AddItemSegue" { //accessing to the segue for adding(segues has special unique key in main storyboard for this purpose "connection")
            if let addItemViewController = segue.destination as? AddItemTableViewController { //making the reference to the additemviewcontroller, we use the prepare's functionality - destination for providing the reference
                addItemViewController.delegate = self //access for delegate property in the additemviewcontroller, now we can get the checklist item from the method wich is in additemviewcontroller
              addItemViewController.todoList = todoList //sending the local todolist into additemviewcontroller
            }
          } else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? AddItemTableViewController {//making the reference to the additemviewcontroller, we use the prepare's functionality - destination for
              if let cell = sender as? UITableViewCell, //here we are getting the cell wich was tapped be the user with help sender and casting it into the UItableviewcell
                 let indexPath = tableView.indexPath(for: cell) { //the indexPath where it was tapped
                let item = todoList.todos[indexPath.row] //get this item on detected position
                addItemViewController.itemToEdit = item //send this item to the property in additemviewcontroller
                addItemViewController.delegate = self
              }
            }
          } else if segue.identifier == "DeleteItem"{
              if let addItemViewController = segue.destination as? AddItemTableViewController {
                  if let cell = sender as? UITableViewCell, //here we are getting the cell wich was tapped be the user with help sender and casting it into the UItableviewcell
                     let indexPath = tableView.indexPath(for: cell) { //the indexPath where it was tapped
                    let item = todoList.todos[indexPath.row] //get this item on detected position
                    addItemViewController.itemToDelete = item //send this item to the property in additemviewcontroller
                    addItemViewController.delegate = self
                  }
              }
          }
          
        }
        
    
    

}

extension ChecklistViewController: AddItemTableViewControllerDelegate { //implementation of the protocol
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
    navigationController?.popViewController(animated: true) //giving the functionality for the method cancel and then the button cancel will work
  }
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    let rowIndex = todoList.todos.count - 1 // total amount of the items in todolist array, it will be the new position of the new checklist item, and -1 is need because there is already item in array
    let indexPath = IndexPath(row: rowIndex, section: 0)// next is standart insertion to the table view new element
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem, flag: Bool) {
    if let index = todoList.todos.index(of: item) { //getting the index of upcoming item from additemviewcontroller
      let indexPath = IndexPath(row: index, section: 0)
        if flag{
            todoList.todos.remove(at: indexPath.row)
            todoList.userDefaultsArray.remove(at: indexPath.row)
            defaults.set(todoList.userDefaultsArray, forKey: "items")
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else{
            if let cell = tableView.cellForRow(at: indexPath) { //getting the cell where this item is located by it's indexPath
                todoList.userDefaultsArray.remove(at: indexPath.row)
                todoList.userDefaultsArray.insert(item.text, at: indexPath.row)
                defaults.set(todoList.userDefaultsArray, forKey: "items")
              configureText(for: cell, with: item) //updating the item
            }

        }
        
        
    }
    navigationController?.popViewController(animated: true)
  }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishDeleting item: ChecklistItem) {
      if let index = todoList.todos.index(of: item) { //getting the index of upcoming item from additemviewcontroller
        let indexPath = IndexPath(row: index, section: 0)
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//        if let cell = tableView.cellForRow(at: indexPath) { //getting the cell where this item is located by it's indexPath
//          configureText(for: cell, with: item) //updating the item
//        }
          
          
      }
      navigationController?.popViewController(animated: true)
    }
    
  
  
}
