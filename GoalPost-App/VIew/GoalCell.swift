//
//  GoalCell.swift
//  GoalPost-App
//
//  Created by Anirudh Bandi on 1/22/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    func configureCell(goal: Goal) {
        self.goalDescription.text =  goal.goalDescription
        self.goalType.text = goal.goalType
        self.goalProgress.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalCompletionValue{
            self.completionView.isHidden = false
        }else {
            self.completionView.isHidden = true
        }
    }
    
}
