//
//  PendingTableViewController.swift
//  TheRevelryChallenge
//
//  Created by Daliso Ngoma on 27/08/2016.
//  Copyright © 2016 Daliso Ngoma. All rights reserved.
//

import UIKit

class PendingTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Local Variables
    
    var tasksController: TasksController {
        get { return (UIApplication.sharedApplication().delegate as! AppDelegate).taskController }
    }
    
    var tasks: [Task] {
        get {
            return tasksController.tasks.filter { $0.state == 0 }
        }
        set {}
    }
    
    var addBarButtonItem: UIBarButtonItem {
        get { return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.pendingBarButtonItemAction(_:))) }
    }
    
    
    var isCancelledTapped: Bool = false
    var changeStateTimer: NSTimer = NSTimer()
    var selectedTaskId: Int?
    
    // MARK: IBOutlets
    
    @IBOutlet var addTaskTextField: UITextField!
    
    // MARK: IBActions
    
    @IBAction func pendingBarButtonItemAction(sender: UIBarButtonItem) {
        addTask(addTaskTextField)
    }
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.tasksController.retrieveFromFile()
            dispatch_async(dispatch_get_main_queue()) {
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tasks", forIndexPath: indexPath) as! TaskTableViewCell
        cell.cancelButton.hidden = true
        
        cell.textLabel?.text = tasks[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTaskId = (tasks[indexPath.row].id! - 1)
        
        let cellCancelButton = (tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell).cancelButton
        cellCancelButton.hidden = false
        cellCancelButton.addTarget(self, action: #selector(self.cancelAction(_:)), forControlEvents: .TouchUpInside)
        startCancelSequence()
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tasksController.deleteTask(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == addTaskTextField {
            addTask(textField)
        }
        
        return true
    }
    
    // MARK: Helper Methods
    
    func cancelAction(sender: AnyObject) {
        
        let cellCancelButton:UIButton? = sender as? UIButton
        
        changeStateTimer.invalidate()
        changeStateTimer = NSTimer()
        navigationItem.rightBarButtonItem = addBarButtonItem
        isCancelledTapped = false
        
        if cellCancelButton != nil {
            cellCancelButton!.hidden = true
        }
        
    }
    
    func startCancelSequence() {
        isCancelledTapped = true
        changeStateTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(self.changeState), userInfo: nil, repeats: false)
    }
    
    func changeState() {
        tasksController.changeTaskState(selectedTaskId!)
        
        tableView.reloadData()
        
        selectedTaskId = nil
    }
    
    func addTask(textField: UITextField) {
        let text = textField.text
        if text != "" {
            tasksController.addNewTask(text)
            
            let insertIndexPaths = [NSIndexPath(forRow: tasks.count-1, inSection: 0)]
            
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Right)
            tableView.endUpdates()
            
            textField.resignFirstResponder()
            textField.text = ""
        }
    }
    
}
