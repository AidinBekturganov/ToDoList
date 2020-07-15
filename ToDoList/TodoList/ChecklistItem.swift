//
//  ChecklistItem.swift
//  ToDoList
//
//  Created by User on 6/30/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    
    @objc var text = ""
    
    var checked = false
    
    func toggleChecked(){
       checked = !checked
    }
    
   
    
}


