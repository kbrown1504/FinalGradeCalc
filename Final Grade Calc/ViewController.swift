//
//  ViewController.swift
//  Final Grade Calc
//
//  Created by Keegan Brown on 5/15/19.
//  Copyright © 2019 Keegan Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var calcStack: UIStackView!
    @IBOutlet weak var currentGradeField: UITextField!
    @IBOutlet weak var percentOfGradeField: UITextField!
    @IBOutlet weak var gradeNeededLabel: UILabel!
    @IBOutlet weak var desiredGradePickerView: UIPickerView!
    
    var gradeOptions: [String] = [String]()
    var selectedRow = 0
    var gradeDesired = 0.0
    var isPortrait = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.desiredGradePickerView.delegate = self
        self.desiredGradePickerView.dataSource = self
        
        gradeOptions = ["A","B","C","D"]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //runs when the view appears for the user and reads initial orientation of the device
        switch UIDevice.current.orientation{
        case UIDeviceOrientation.landscapeLeft:
            isPortrait = false
        case UIDeviceOrientation.landscapeRight:
            isPortrait = false
        case UIDeviceOrientation.portrait:
            isPortrait = true
        default:
            break
        }
        
        if isPortrait == true {
            self.safeAreaPortrait.priority = UILayoutPriority(999.0)
            self.safeAreaLandscape.priority = UILayoutPriority(1.0)
            calcStack.axis  = .vertical
            
        } else {
            self.safeAreaLandscape.priority = UILayoutPriority (999.0)
            self.safeAreaPortrait.priority = UILayoutPriority (1.0)
            calcStack.axis = .horizontal
            print("It is landscape")
        }
    }
    
    override func didReceiveMemoryWarning() {
        //Dispose of any resources that can be recreated
    }
    
    //Get number of columns of data. We return one because we are using a 1x4 array
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Gets number of rows of data for pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradeOptions.count
    }
    
    //sets data to be displayed for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradeOptions[row]
    }
    
    //gets what row is currently selected every time that the pickerView is moved.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    //does the calculations for the final grade
    func doTheMath(current : Double, percentOfGrade : Double, gradeDesired : Double){
        
        let decimalPercentOfGrade = percentOfGrade / 100
        
        let currentMod = (1-decimalPercentOfGrade) * current
        
        let percentToRecover = gradeDesired - currentMod
        
        let needToGet = percentToRecover / decimalPercentOfGrade
        
        let needToGetString = String(format:"%.2f" , needToGet)
        
        //sets color
        if needToGet <= 100 {
            self.view.backgroundColor = .green
            
            var gradeAlertString = ""
            
            if needToGet>=80{
                gradeAlertString = "You need to get \(needToGetString)% or higher on your final. Time to get studying!"
            } else if needToGet>=60{
                gradeAlertString = "You need to get \(needToGetString)% or higher on your final. You can probably just cram right before the test."
            } else if needToGet>=40{
                gradeAlertString  = "You need to get \(needToGetString)% or higher on you final. You don't need to study."
            } else if needToGet<=0{
                gradeAlertString = "You could get a zero and be fine. Just turn it in blank."
            } else{
                gradeAlertString = "You on need to get \(needToGetString)% or higher on your final. You're worried about it? Don't even worry about it."
            }
            
            let gradeAlert = UIAlertController (title: "Good work this semester!", message: gradeAlertString, preferredStyle: .alert)
            let gradeAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            gradeAlert.addAction(gradeAction)
            self.present(gradeAlert, animated: true, completion: nil)
            
        } else{
            self.view.backgroundColor = .red
            
            //setting up and implementing the alert
            let extraCreditAlert = UIAlertController (title: "You need at least \(needToGetString)%", message: "You should ask you teacher for some extra credit and start studying!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .cancel
                , handler: nil)
            extraCreditAlert.addAction(action1)
            self.present(extraCreditAlert, animated: true, completion: nil)
            
        }
        
        let formattedGradeNeeded = String (format: "%.2f" , needToGet)
        gradeNeededLabel.text = "\(formattedGradeNeeded)%"
        
    }
    
    @IBAction func onClacPressed(_ sender: UIButton) {
        
        let currentGrade = Double(currentGradeField.text!)
        let percentageOfGrade = Double(percentOfGradeField.text!)
        
        if currentGrade == nil || percentageOfGrade == nil{
            
            let invalidEntryAlert = UIAlertController(title: "ERROR", message: "Please enter valid values and try again.", preferredStyle: .alert)
            let errorAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            invalidEntryAlert.addAction(errorAction)
            self.present(invalidEntryAlert, animated: true, completion: nil)
            return
            
        } else {
            
            switch selectedRow {
            case 0:
                gradeDesired = 90.0
            case 1:
                gradeDesired = 80.0
            case 2:
                gradeDesired = 70.0
            case 3:
                gradeDesired = 60.0
            default:
                break
                
            }
            
            doTheMath(current: currentGrade!, percentOfGrade: percentageOfGrade!, gradeDesired: gradeDesired)
            
            percentOfGradeField.text = ""
            currentGradeField.text = ""
            
        }
        
    }
    
    //Shake Gesture will sense when motion begins and react. Code within is the same as the code in the calculate button action.
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        let currentGrade = Double(currentGradeField.text!)
        let percentageOfGrade = Double(percentOfGradeField.text!)
        
        if currentGrade == nil || percentageOfGrade == nil{
            
            let invalidEntryAlert = UIAlertController(title: "ERROR", message: "Please enter valid values and try again.", preferredStyle: .alert)
            let errorAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            invalidEntryAlert.addAction(errorAction)
            self.present(invalidEntryAlert, animated: true, completion: nil)
            return
            
        } else {
            
            switch selectedRow {
            case 0:
                gradeDesired = 90.0
            case 1:
                gradeDesired = 80.0
            case 2:
                gradeDesired = 70.0
            case 3:
                gradeDesired = 60.0
            default:
                break
                
            }
            
            doTheMath(current: currentGrade!, percentOfGrade: percentageOfGrade!, gradeDesired: gradeDesired)
            
            percentOfGradeField.text = ""
            currentGradeField.text = ""
            
        }
        
    }
    
    @IBOutlet weak var safeAreaLandscape: NSLayoutConstraint!
    @IBOutlet weak var safeAreaPortrait: NSLayoutConstraint!
    
    override func viewSafeAreaInsetsDidChange() {
        
        switch UIDevice.current.orientation{
        case UIDeviceOrientation.landscapeLeft:
            isPortrait = false
        case UIDeviceOrientation.landscapeRight:
            isPortrait = false
        case UIDeviceOrientation.portrait:
            isPortrait = true
        default:
            break
        }
        
        if isPortrait == true {
            self.safeAreaPortrait.priority = UILayoutPriority(999.0)
            self.safeAreaLandscape.priority = UILayoutPriority(1.0)
            calcStack.axis  = .vertical
            
        } else {
            self.safeAreaLandscape.priority = UILayoutPriority (999.0)
            self.safeAreaPortrait.priority = UILayoutPriority (1.0)
            calcStack.axis = .horizontal
            print("It is landscape")
        }
        
    }
    
}
