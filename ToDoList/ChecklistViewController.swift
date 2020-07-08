//
//  ViewController.swift
//  ToDoList
//
//  Created by User on 6/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var toDoList: ToDoList
    let defaults = UserDefaults.standard
    var addItem: ItemDetailViewController
    
    
   // @IBOutlet weak var checkMark: UIImageView!
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = toDoList.toDos.count
        _ = toDoList.newToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        toDoList = ToDoList()
        addItem = ItemDetailViewController()
        super.init(coder: aDecoder)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        
    
        
    }
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        
        
        let item = toDoList.toDos[indexPath.row]
        if !toDoList.checkMarkUserDefaults.isEmpty{
//            for i in toDoList.checkMarkUserDefaults{
//                let checkmark = i
//                item.checked = checkmark
//                configureCheckmark(for: cell, with: item)
//            }
//            configureText(for: cell, with: item)
            
        }else{
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
            
                 
        
         return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            
                let item = toDoList.toDos[indexPath.row]
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
                }
            
        }
    
    
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        if let label = cell.viewWithTag(1000) as? UILabel { // tag means the given identifier for the cell in table view manually, tag is set in the main storyboard
            
          label.text = item.text
            // item.text - text is the property of the CheckListItem class, used for converting the arrat item into String P.S. check out TodoList class and CheckListItem class
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        guard let checkmark = cell.viewWithTag(1004) as? UIImageView else { //given identifier in the main storyboard
          return
        }
        //toDoList.checkMarkUserDefaults.append(item.checked)
        if item.checked {
            checkmark.image = UIImage(named: "correct")
                let indexPath = tableView.indexPath(for: cell)
                toDoList.checkMarkUserDefaults.remove(at: indexPath!.row)
                toDoList.checkMarkUserDefaults.insert(item.checked, at: indexPath!.row)
            
            
            
        } else {
          checkmark.image = UIImage(named: "emptymark")
            let indexPath = tableView.indexPath(for: cell)
            //let oldItem = toDoList.toDos[indexPath!.row]
            if let index = indexPath?.row{
                    toDoList.checkMarkUserDefaults.remove(at: index)
                    toDoList.checkMarkUserDefaults.insert(item.checked, at: indexPath!.row)
            }
            
            

        }
        // item.checked - checked is the property of the Checklistitem class which is bool, by default it is false, also there is a func toggleChecked() for revercing the checked property
        // the if statement for switching position of the checkmark
       print(toDoList.checkMarkUserDefaults)
        
        item.toggleChecked()
        defaults.set(toDoList.checkMarkUserDefaults, forKey: "checkmark")

    }
        
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue"{
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = toDoList
            }
        }else if segue.identifier == "EditItemSegue"{
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                    let item = toDoList.toDos[indexPath.row]
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.delegate = self
                }
            }
        } else if segue.identifier == "DeleteItem"{
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell, //here we are getting the cell wich was tapped be the user with help sender and casting it into the UItableviewcell
                   let indexPath = tableView.indexPath(for: cell) { //the indexPath where it was tapped
                  let item = toDoList.toDos[indexPath.row] //get this item on detected position
                    addItemViewController.itemToDelete = item //send this item to the property in additemviewcontroller
                  addItemViewController.delegate = self
                }
            }
        }
    }
    
    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate{
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = toDoList.toDos.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem, flag: Bool) {
        
        if let index = toDoList.toDos.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if flag{
                toDoList.toDos.remove(at: indexPath.row)
                toDoList.userDefaultsArray.remove(at: indexPath.row)
                defaults.set(toDoList.userDefaultsArray, forKey: "items")
                print("Array after deleting: \(toDoList.userDefaultsArray)")
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }else{
                if let cell = tableView.cellForRow(at: indexPath){
                    toDoList.userDefaultsArray.remove(at: indexPath.row)
                    toDoList.userDefaultsArray.insert(item.text, at: indexPath.row)
                    defaults.set(toDoList.userDefaultsArray, forKey: "items")
                    print("Array after deleting: \(toDoList.userDefaultsArray)")
                    configureText(for: cell, with: item) //updating the item
                }
            }


        }
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishDeleting item: ChecklistItem) {
        if let index = toDoList.toDos.firstIndex(of: item) { //getting the index of upcoming item from additemviewcontroller
            let indexPath = IndexPath(row: index, section: 0)
            toDoList.toDos.remove(at: indexPath.row)
            toDoList.checkMarkUserDefaults.remove(at: indexPath.row)
            defaults.set(toDoList.checkMarkUserDefaults, forKey: "checkmark")
            print(toDoList.checkMarkUserDefaults)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
              
              
          }
          navigationController?.popViewController(animated: true)
        }
}
