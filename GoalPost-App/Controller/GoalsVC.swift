//
//  ViewController.swift
//  GoalPost-App
//
//  Created by Anirudh Bandi on 1/22/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var undoView = UIView()

    var goals: [Goal] = []
    var deletedRow = 0
    
    var deletedGoalName : String?
    var deletedGoalType : String?
    var deletedGoalProgress: Int32?
    var deleltedGoalCompletionValue: Int32?
    
    
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
        addUndoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view appeared")
        fetchCoreDataObjects()
    }

    func fetchCoreDataObjects(){
        print("entered fetch data")
        self.fetch { (complete) in
            print("completed")
            if complete{
                if goals.count > 0{
                    print("table reloaded")
                    tableView.isHidden = false
                    tableView.reloadData()
                } else {
                    print("table empty")
                    tableView.isHidden = true
                }
            }
        }
    }
    
    func addUndoView(){
        let x = CGFloat(10)
        undoView = UIView(frame: CGRect(x: x, y: UIScreen.main.bounds.height-60, width: UIScreen.main.bounds.width - 2*x, height: 50))
        undoView.backgroundColor = UIColor.red
        undoView.layer.cornerRadius = 10.0
        undoView.layer.masksToBounds = true
        self.view.addSubview(undoView)
        
        let labelHeight: CGFloat = 50
        let labelWidth: CGFloat = 150
        let label = UILabel(frame: CGRect(x: 10, y: undoView.frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        label.text = "Goal Removed"
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.textColor = UIColor.white
        undoView.addSubview(label)
        
        let buttonHeight: CGFloat = 30
        let buttonWidth: CGFloat = 55
        let undoButton = UIButton(frame: CGRect(x: undoView.frame.width-buttonWidth-5, y: undoView.frame.height/2-buttonHeight/2, width: buttonWidth, height: buttonHeight))
        undoButton.backgroundColor = UIColor.clear
        undoButton.setTitleColor(UIColor.white, for: .normal)
        undoButton.setTitle("UNDO", for: .normal)
        undoButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        
        undoButton.addTarget(self, action:#selector(undoButtonTapped), for: .touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x:undoView.frame.width-buttonWidth-25-undoButton.frame.width , y: undoView.frame.height/2-buttonHeight/2, width: buttonWidth + 20, height: buttonHeight))
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        
        cancelButton.addTarget(self, action:#selector(cancelButtonTapped), for: .touchUpInside)
        
        undoView.addSubview(cancelButton)
        undoView.addSubview(undoButton)
        undoView.isHidden = true
        
    }
    @objc func undoButtonTapped(){
        if deletedGoalName != nil {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        goal.goalDescription = deletedGoalName!
        goal.goalType = deletedGoalType!
        goal.goalCompletionValue = deleltedGoalCompletionValue!
        goal.goalProgress  = deletedGoalProgress!
        
        do {
            try managedContext.save()
            print("Successfully saved data.")
            fetchCoreDataObjects()
            undoView.isHidden = true
            setDeletedGoalToNil()
        }catch {
            debugPrint("Could Not Save: \(error.localizedDescription)")
        }
        }else{
            return
        }
        
    }
    
    @objc func cancelButtonTapped(){

        undoView.isHidden = true
        setDeletedGoalToNil()
}
    
    func setDeletedGoalToNil(){
        self.deletedGoalName = nil
        self.deletedGoalType = nil
        self.deletedGoalProgress = nil
        self.deleltedGoalCompletionValue = nil
    }


}
extension GoalsVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell()}
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
           
            self.undoView.isHidden = false
            self.deletedRow = indexPath.row
            tableView.beginUpdates()
            let goal = self.goals[indexPath.row]
            
            self.deletedGoalName = goal.goalDescription
            self.deletedGoalType = goal.goalType
            self.deletedGoalProgress = goal.goalProgress
            self.deleltedGoalCompletionValue = goal.goalCompletionValue
            
            self.removeGoal(atIndexPathRow: self.deletedRow)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        addAction.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        
        return [deleteAction, addAction]
        
    }
}

extension GoalsVC {
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let choosenGoal = goals[indexPath.row]
        
        if choosenGoal.goalProgress < choosenGoal.goalCompletionValue {
            choosenGoal.goalProgress += 1
        } else {
            return
        }
        do {
            try manageContext.save()
            print("successfully set progress")
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func removeGoal(atIndexPathRow indexPathRow: Int) {
        
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        manageContext.delete(goals[indexPathRow])
        do {
            try manageContext.save()
        }catch {
            debugPrint(error.localizedDescription)
        }
    }
    func fetch(completion: (_ complete:Bool) -> () ){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do{
            print("inside do")
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}

