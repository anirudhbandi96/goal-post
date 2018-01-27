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
    func wiggle() {
            
            let wiggleAnim = CABasicAnimation(keyPath: "position")
            wiggleAnim.duration = 0.05
            wiggleAnim.repeatCount = 5
            wiggleAnim.autoreverses = true
            wiggleAnim.fromValue = CGPoint(x: self.center.x-4.0, y: self.center.y)
            wiggleAnim.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
            self.layer.add(wiggleAnim, forKey: "position")
            
        }
    
}
