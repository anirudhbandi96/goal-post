//
//  CreateGoalVC.swift
//  GoalPost-App
//
//  Created by Anirudh Bandi on 1/22/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextbtn.bindToKeyboard()
        shortTermBtn.setSelectedColor()
        longTermButton.setDeselectedColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermBtn.setDeselectedColor()
        longTermButton.setSelectedColor()
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
}
