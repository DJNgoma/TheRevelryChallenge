//
//  Task.swift
//  TheRevelryChallenge
//
//  Created by Daliso Ngoma on 27/08/2016.
//  Copyright © 2016 Daliso Ngoma. All rights reserved.
//

import Foundation

struct Task {
    var id: Int?
    var name: String?
    var state: Int?
    
    init(id: Int?, name: String?, state: Int? = 0) {
        self.id = id
        self.name = name
        self.state = state
    }
    
    func description() -> String {
        return "id: \(id)\nname: \(name)\nstate: \(state)\n"
    }
}