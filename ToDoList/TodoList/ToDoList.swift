//
//  ToDoList.swift
//  ToDoList
//
//  Created by User on 6/30/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation


class ToDoList{
    
   
    
    var toDos: [ChecklistItem] = []
    var filteredItems: [ChecklistItem] = []
    let defaults = UserDefaults.standard
    
    func loadData(){
       if let data = UserDefaults.standard.value(forKey:"items") as? Data {
                  guard let toDos2 = try? PropertyListDecoder().decode([ChecklistItem].self, from: data) else{
                      return
                  }
                    let item = ChecklistItem()
                    item.checked = !item.checked
                  toDos = toDos2
                    
                  
       } else{
           toDos = []
       }
    }
    
    init() {
        
    }
    
   
    func newToDo() -> ChecklistItem{
        let item = ChecklistItem()
        item.checked = true
        //checkMarkUserDefaults.append(false)
        toDos.append(item)
        return item
    }
    
    
   
    
}
