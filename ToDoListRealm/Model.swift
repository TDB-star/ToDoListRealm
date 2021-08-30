//
//  Model.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 28/08/2021.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
}

class TaskList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    
    let tasks = List<Task>()
}
