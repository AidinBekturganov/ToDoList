//
//  ViewController.swift
//  ToDoList
//
//  Created by User on 7/13/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var menuButtom: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNav()
        sideMunes()
        // Do any additional setup after loading the view.
    }
    
    func sideMunes(){
        
        if revealViewController() != nil{
            menuButtom.target = revealViewController()
            menuButtom.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

            
        }
        
    }
    
    func customizeNav(){
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 12/255, blue: 51/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
