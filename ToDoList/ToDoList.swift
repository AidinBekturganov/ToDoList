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
//   var userDefaultsArray: [String] = []
//    var checkMarkUserDefaults: [Bool] = []
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
        
        
        
//        if let array = defaults.object(forKey: "items") as? [String]{
//
//            if let arrayOfCheckMarks = defaults.object(forKey: "checkmark") as? [Bool]{
//                for i in arrayOfCheckMarks{
//                    //print(arrayOfCheckMarks)
//                    checkMarkUserDefaults.append(i)
//
//
//
//                }
//            }else{
//                for i in 1...array.count{
//                    checkMarkUserDefaults.append(false)
//
//             }
//           }
//
//
//
//            for i in array{
//                let tasks: ChecklistItem
//                tasks = ChecklistItem()
//                tasks.text = i
//                userDefaultsArray.append(i)
//                toDos.append(tasks)
//            }
//        }
        
    }
    
   
    func newToDo() -> ChecklistItem{
        let item = ChecklistItem()
        item.checked = true
        //checkMarkUserDefaults.append(false)
        toDos.append(item)
        return item
    }
    
    
   
    
}
