//
//  ViewController.swift
//  ToDoList
//
//  Created by User on 6/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit
import ViewAnimator

class ChecklistViewController: UITableViewController {
    var toDoList: ToDoList
    var addItem: ItemDetailViewController
    var checkMarkToggle: ChecklistItem
    var searchController = UISearchController(searchResultsController: nil)
    var searchIsEmpty: Bool{
            guard let text = searchController.searchBar.text else {
                return false
            }
            return text.isEmpty
        }
    var isFiltering: Bool{
            searchController.isActive && !searchIsEmpty
        }
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
            checkMarkToggle = ChecklistItem()
            super.init(coder: aDecoder)
        }
        
        
    override func viewDidLoad() {
            super.viewDidLoad()
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search"
            navigationItem.searchController = searchController
            definesPresentationContext = true
            sideMunes()
            customizeNav()
            toDoList.loadData()
            checkMarkToggle.checked = !checkMarkToggle.checked
            navigationController?.navigationBar.prefersLargeTitles = true
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            
        }
    
   
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            let animation = AnimationType.from(direction: .top, offset: 300)
            UIView.animate(views: tableView.visibleCells, animations: [animation])
        }
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isFiltering{
                return toDoList.filteredItems.count
            }
            return toDoList.toDos.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
            
            var item: ChecklistItem
            
            if isFiltering{
                item = toDoList.filteredItems[indexPath.row]
            }else{
                item = toDoList.toDos[indexPath.row]
            }
                configureText(for: cell, with: item)
                configureCheckmark(for: cell, with: item)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoList.toDos), forKey:"items")

            cell.textLabel?.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
             return cell
        }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
                let item = toDoList.toDos[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
                

            UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoList.toDos), forKey:"items")

                }
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func customizeNav(){
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barTintColor = .white
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


       }
    
    func sideMunes(){
             if revealViewController() != nil{
                 menuButton.target = revealViewController()
                 menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                 revealViewController().rearViewRevealWidth = 250
                 
                 
                 
                 view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

             
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
              if item.checked {
                checkmark.image = UIImage(named: "correct1x")

              }else {
                checkmark.image = UIImage(named: "123")

                }
            // item.checked - checked is the property of the Checklistitem class which is bool, by default it is false, also there is a func toggleChecked() for revercing the checked property
            // the if statement for switching position of the checkmark
       

        }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
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
                        
                        let item: ChecklistItem
                        if isFiltering{
                            item = toDoList.filteredItems[indexPath.row]
                        }else{
                            item = toDoList.toDos[indexPath.row]
                        }
                        itemDetailViewController.itemToEdit = item
                        itemDetailViewController.delegate = self
                    }
                }
            }
        }
    
    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ serchText: String){
        toDoList.filteredItems = toDoList.toDos.filter({(todo: ChecklistItem) -> Bool in
            return todo.text.lowercased().contains(serchText.lowercased())
        })
        tableView.reloadData()
    }
    
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
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .automatic)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoList.toDos), forKey:"items")

            }else{
                if let cell = tableView.cellForRow(at: indexPath){
                    configureText(for: cell, with: item) //updating the item
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoList.toDos), forKey:"items")

                }
            }


        }
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishDeleting item: ChecklistItem) {
        if let index = toDoList.toDos.firstIndex(of: item) { //getting the index of upcoming item from additemviewcontroller
            let indexPath = IndexPath(row: index, section: 0)
            toDoList.toDos.remove(at: indexPath.row)
                 let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
              
              
          }
          navigationController?.popViewController(animated: true)
        }
}
