//
//  CheckListTableViewCell.swift
//  ToDoList
//
//  Created by User on 7/3/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
