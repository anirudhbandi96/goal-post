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
    
    func configureCell(description: String, goalType: GoalType, goalProgress: Int) {
        self.goalDescription.text =  description
        self.goalType.text = goalType.rawValue
        self.goalProgress.text = String(describing: goalProgress)
    }
    
}
