//
//  WatchWithEndViewController.swift
//  StopWatch
//
//  Created by User on 6/24/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class WatchWithEndViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var secondsPicker: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var labelForNums: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    var time = Timer()
    var flagForStopButton = false
    
    var arrayOfSeconds: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    var arrayOfMinutes: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    var arrayOfHours: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondsPicker.delegate = self
        secondsPicker.dataSource = self
        labelForNums.isHidden = true
         sideMunes()
        customizeNav()
    }
    
    func customizeNav(){
        
            navigationController?.navigationBar.tintColor = .red
            navigationController?.navigationBar.barTintColor = .black;     navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    
    func sideMunes(){
        
        if revealViewController() != nil{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                revealViewController().rearViewRevealWidth = 250
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

            }
        
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return arrayOfHours[row]
        } else if component == 1{
            return arrayOfMinutes[row]
        }
        
        return arrayOfSeconds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0{
                return arrayOfHours.count
            } else if component == 1{
                return arrayOfMinutes.count
            }
            
        return arrayOfSeconds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if component == 0{
            hours = Int(arrayOfHours[row]) ?? 0
        } else if component == 1{
            minutes = Int(arrayOfMinutes[row]) ?? 0
        } else {
            seconds = Int(arrayOfSeconds[row]) ?? 0
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        if !time.isValid || startButton.currentBackgroundImage == #imageLiteral(resourceName: "play-button copy"){
         startButton.setBackgroundImage(#imageLiteral(resourceName: "play-button copy"), for: .normal)
            if seconds != 0 || minutes != 0 || hours != 0 {
                time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector (keepTimerDescending), userInfo: nil, repeats: true)
                stopButton.isEnabled = true
                secondsPicker.isHidden = true
                labelForNums.isHidden = false
                startButton.setBackgroundImage(#imageLiteral(resourceName: "pause1x"), for: .normal)
            }
            
            
        }else{
            startButton.setBackgroundImage(#imageLiteral(resourceName: "play-button copy"), for: .normal)
            time.invalidate()
        }
       
    }
    
    @objc func keepTimerDescending(){
        if seconds == 0{
            if seconds == 0 && minutes == 0 && hours == 0{
               time.invalidate()
            }
            if seconds == 0 && minutes != 0{
                minutes -= 1
                seconds = 60
            }
            if (seconds == 0 && minutes == 0) && hours != 0{
                seconds = 60
                minutes = 59
                hours -= 1
            }
        }else{
            seconds -= 1
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        labelForNums.text = "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    
    @IBAction func stopButtonForTimer(_ sender: Any) {
        time.invalidate()
        seconds = 0
        minutes = 0
        hours = 0
        labelForNums.text = "00:00:00"
        stopButton.isEnabled = false
        secondsPicker.selectRow(0, inComponent: 0, animated: true)
        secondsPicker.selectRow(0, inComponent: 1, animated: true)
        secondsPicker.selectRow(0, inComponent: 2, animated: true)
        secondsPicker.isHidden = false
        labelForNums.isHidden = true
        startButton.setBackgroundImage(#imageLiteral(resourceName: "play-button copy"), for: .normal)
        
    }
    
    
    
    
    @IBAction func toGetBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
