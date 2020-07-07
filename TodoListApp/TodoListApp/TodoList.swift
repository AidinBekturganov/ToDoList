//
//  TodoList.swift
//  TodoListApp
//
//  Created by User on 7/7/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation


import Foundation

class TodoList {
    
    
    var todos: [ChecklistItem] = [] //the array wich handling all data about tasks
    var userDefaultsArray: [String] = []
    let defaults = UserDefaults.standard
    var count = 0
    
    init() {
        
        if let array = defaults.object(forKey: "items") as? [String]{
            print(array)
            
            
            for i in array{
                let tasks: ChecklistItem
                tasks = ChecklistItem()
                tasks.text = i
                print(i)
                userDefaultsArray.append(i)
                todos.append(tasks)
            }
        }
        
    }
    
    func putBack(item: ChecklistItem){
        todos.append(item)
    }
    
  func newTodo() -> ChecklistItem { //the func for managing adding the new tasks into array
    let item = ChecklistItem() //generating a new check list item
    item.checked  = true //by default it is checked checkmark
    todos.append(item)
    return item
  }
  
}
