//
//  AppDelegate.swift
//  TheRevelryChallenge
//
//  Created by Daliso Ngoma on 27/08/2016.
//  Copyright © 2016 Daliso Ngoma. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var taskController = TasksController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        NetworkActivityIndicatorManager.sharedManager.completionDelay = 1
        
        return true
    }

}

