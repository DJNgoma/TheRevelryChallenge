//
//  TasksController.swift
//  TheRevelryChallenge
//
//  Created by Daliso Ngoma on 27/08/2016.
//  Copyright © 2016 Daliso Ngoma. All rights reserved.
//

import Foundation
import SwiftyJSON

class TasksController {
    
    var tasks:[Task] = []
    
    func retrieveFromNetwork() {
        let requestURL: NSURL = NSURL(string: Config.tasksUrl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                let json = JSON(data: data!)["data"].arrayValue
                self.tasks = json.map{
                    Task(
                        id:    $0["id"].int,
                        name:  $0["name"].string,
                        state: $0["state"].int
                    ) }
                print("The tasks are: \(self.tasks)")
            }
        }
        
        task.resume()
    }
    
    func retrieveFromFile() {
        guard
            let jsonPath = NSBundle.mainBundle().pathForResource("tasks", ofType: "json"),
            let jsonFile = NSData(contentsOfFile: jsonPath)
            else { print("Error: No Task File Found"); return }
        
        let json = JSON(data: jsonFile)["data"].arrayValue
        
        tasks = json.map{
            Task(
                id:    $0["id"].int,
                name:  $0["name"].string,
                state: $0["state"].int
            ) }
    }
    
    func addNewTask(name: String?) {
        tasks.append(Task(id: tasks.count+1, name: name))
    }
    
    func deleteTask(atPosition: Int) {
        tasks.removeAtIndex(atPosition)
    }
    
    func changeTaskState(atIndex: Int) {
        if tasks[atIndex].state == 0 {
            tasks[atIndex].state = 1
        }
        else if tasks[atIndex].state == 1 {
            tasks[atIndex].state = 0
        }
    }
}