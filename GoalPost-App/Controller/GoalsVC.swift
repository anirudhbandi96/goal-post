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
    
    var undoViewBottomAnchorConstraint: NSLayoutConstraint?
    
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
        fetchCoreDataObjects()
    }

    func fetchCoreDataObjects(){
        self.fetch { (complete) in
            if complete{
                if goals.count > 0{
                    tableView.isHidden = false
                    tableView.reloadData()
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    func animateUndoView(){
        
        UIView.animate(withDuration: 0.3) {
            self.undoViewBottomAnchorConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }
    }
    
    func removeUndoView(){
        
        UIView.animate(withDuration: 0.3) {
            self.undoViewBottomAnchorConstraint?.constant = 80
            self.view.layoutIfNeeded()
        }
    }
    
    func addUndoView(){
        
        undoView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        undoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(undoView)

        undoView.backgroundColor = UIColor.red
        undoView.layer.cornerRadius = 10.0
        undoView.layer.masksToBounds = true
        
        let margins = view.layoutMarginsGuide
        
        undoView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        undoView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        undoViewBottomAnchorConstraint = undoView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 80)
        undoViewBottomAnchorConstraint?.isActive = true
        undoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let labelHeight: CGFloat = 50
        let labelWidth: CGFloat = 150
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
        label.translatesAutoresizingMaskIntoConstraints = false
        self.undoView.addSubview(label)
        
        label.text = "Goal Removed"
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.textColor = UIColor.black

        label.leadingAnchor.constraint(equalTo: undoView.leadingAnchor, constant: 25).isActive = true
        label.centerYAnchor.constraint(equalTo: undoView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: labelHeight)
        label.widthAnchor.constraint(equalToConstant: labelWidth)

        
        
        let buttonHeight: CGFloat = 20
        let buttonWidth: CGFloat = 50
        let undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoView.addSubview(undoButton)
        
        undoButton.backgroundColor = UIColor.clear
        undoButton.setTitleColor(UIColor.black, for: .normal)
        undoButton.setTitle("UNDO", for: .normal)
        undoButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        
        undoButton.trailingAnchor.constraint(equalTo: undoView.trailingAnchor, constant: -10).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        undoButton.centerYAnchor.constraint(equalTo: undoView.centerYAnchor).isActive = true

        undoButton.addTarget(self, action:#selector(undoButtonTapped), for: .touchUpInside)

        let cancelButton = UIButton(frame: CGRect(x:0 , y: 0, width: buttonWidth + 20, height: buttonHeight))
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        undoView.addSubview(cancelButton)
        
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)

        cancelButton.addTarget(self, action:#selector(cancelButtonTapped), for: .touchUpInside)

        cancelButton.trailingAnchor.constraint(equalTo: undoButton.leadingAnchor, constant: -10).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: undoView.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: buttonWidth+15).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        //undoView.isHidden = true
        
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
            removeUndoView()
            setDeletedGoalToNil()
        }catch {
            debugPrint("Could Not Save: \(error.localizedDescription)")
        }
        }else{
            return
        }
        
    }
    
    @objc func cancelButtonTapped(){
        self.removeUndoView()
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
           
            self.animateUndoView()
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
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}

