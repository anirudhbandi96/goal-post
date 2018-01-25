//
//  ViewController.swift
//  GoalPost-App
//
//  Created by Anirudh Bandi on 1/22/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "createGoalVC") else { return }
        presentDetail(createGoalVC)
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }

   


}

extension GoalsVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell()}
        cell.configureCell(description: "eat salad twice a week", goalType:.shortTerm, goalProgress: 2)
        
        return cell
    }
}

