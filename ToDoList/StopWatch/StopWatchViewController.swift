//
//  ViewController.swift
//  StopWatch
//
//  Created by User on 6/23/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    
    var time = Timer()
    var (hours, minutes, seconds) = (0, 0, 0)
    var savedPauses: [String] = []
    var flagForResetEnable = true

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopButtonAndReset: UIButton!
    @IBOutlet weak var startButtonToEnableReset: UIButton!
    @IBOutlet weak var switchStartAndStop: UISwitch!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMunes()
        customizeNav()
        
    }
    func customizeNav(){
        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.barTintColor = .black;           navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


       }
    
    func sideMunes(){
        
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

            
        }
        
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        
        
        if time.isValid || stopButtonAndReset.currentBackgroundImage == #imageLiteral(resourceName: "clock_1x"){
            let currentTime = "\(hours):\(minutes):\(seconds) is lap №\(savedPauses.count + 1)"
            savedPauses.append(currentTime)
            let indexPath = IndexPath(row: savedPauses.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        } else if flagForResetEnable{
            time.invalidate()
            (hours, minutes, seconds) = (0, 0, 0)
            timeLabel.text = "00:00:00"
            stopButtonAndReset.isEnabled = false
            savedPauses = []
            tableView.reloadData()
            stopButtonAndReset.setBackgroundImage(#imageLiteral(resourceName: "reload1x"), for: .normal)

        }
        
    }
    
  

    @IBAction func continueButton(_ sender: UIButton) {
        if !time.isValid || startButtonToEnableReset.currentBackgroundImage == #imageLiteral(resourceName: "play-button copy") {
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StopWatchViewController.keepTimer), userInfo: nil, repeats: true)
            startButtonToEnableReset.setBackgroundImage(#imageLiteral(resourceName: "pause1x"), for: .normal)
            stopButtonAndReset.setBackgroundImage(#imageLiteral(resourceName: "clock_1x"), for: .normal)
            stopButtonAndReset.isEnabled = true
        } else {
                time.invalidate()
            flagForResetEnable = true
            startButtonToEnableReset.setBackgroundImage(#imageLiteral(resourceName: "play-button copy"), for: .normal)
            stopButtonAndReset.setBackgroundImage(#imageLiteral(resourceName: "reload1x"), for: .normal)
        }
    }
    
  
    
    @objc func keepTimer(){

            seconds += 1
            if seconds > 60{
                    minutes += 1
                    seconds = 0
                }
            
            if minutes > 60{
                    hours += 1
                    minutes = 0
                }
            
            let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            let hourString = hours > 9 ? "\(hours)" : "0\(hours)"

            timeLabel.text = "\(hourString):\(minuteString):\(secondString)"
        }
    
   
    
    
}

extension StopWatchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPauses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = savedPauses[indexPath.row]
        return cell
    }
    
}
