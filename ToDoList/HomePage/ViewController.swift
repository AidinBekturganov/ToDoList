//
//  ViewController.swift
//  ToDoList
//
//  Created by User on 7/13/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit
import ViewAnimator

class ViewController: UIViewController {

    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var menuButtom: UIBarButtonItem!
    
    
    var titleLabel = UILabel()
    var bodyLabel = UILabel()
    var ifTheAnimationHasBeenShown = false

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNav()
        sideMunes()
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        titleLabel.text = "Hello Dear Friend!"
        titleLabel.font = UIFont(name: "Futura", size: 35)
        bodyLabel.text = "Hope you are doing well :)\nThis app is the little helper for you\nYour little UNIpod"
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)
        if !ifTheAnimationHasBeenShown{
            titleLabel.animate(animations: [AnimationType.rotate(angle: .pi/5)], delay: 1, duration: 1)
            bodyLabel.animate(animations: [AnimationType.zoom(scale: 1)], delay: 2, duration: 2)
            ifTheAnimationHasBeenShown = true
        }
        
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

}
