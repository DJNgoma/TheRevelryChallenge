//
//  DoneTableViewController.swift
//  
//
//  Created by Daliso Ngoma on 27/08/2016.
//
//

import UIKit

class DoneTableViewController: UITableViewController {

    // Local Variables
    var selectedTaskId: Int?
    var isCancelledTapped: Bool = false
    var changeStateTimer: NSTimer = NSTimer()
    
    var tasksController: TasksController {
        get { return (UIApplication.sharedApplication().delegate as! AppDelegate).taskController }
    }
    
    var tasks: [Task] { get { return tasksController.tasks.filter { $0.state == 1 } } }
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTable), name: "Reload Tasks", object: nil)
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

    // MARK: Helper Methods
    
    func cancelAction(sender: AnyObject) {
        
        let cellCancelButton:UIButton? = sender as? UIButton
        
        changeStateTimer.invalidate()
        changeStateTimer = NSTimer()
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
        navigationItem.rightBarButtonItem = nil
        
        selectedTaskId = nil
        isCancelledTapped = false
        tableView.reloadData()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }

}
