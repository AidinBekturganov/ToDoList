//
//  ChecklistItem.swift
//  TodoListApp
//
//  Created by User on 7/7/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject { //making the subclass of the NSObject, which allow us to compare items with other items
  
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
  
}

