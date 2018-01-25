//
//  UIButtonExt.swift
//  GoalPost-App
//
//  Created by Anirudh Bandi on 1/24/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor(){
        self.backgroundColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
    }
    
    func setDeselectedColor(){
        self.backgroundColor = #colorLiteral(red: 0.6519300938, green: 0.8728946447, blue: 0.6689990759, alpha: 1)
    }
}
