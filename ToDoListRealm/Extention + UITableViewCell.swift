//
//  Extention + UITableViewCell.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 30/08/2021.
//

import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskList) {
        
       let currentTasks = taskList.tasks.filter("isCompleted = false")
       let completedTasks = taskList.tasks.filter("isCompleted = true")
        
        var content = defaultContentConfiguration()
        content.text = taskList.name
        
        if !currentTasks.isEmpty {
            content.secondaryText = "\(currentTasks.count)"
            accessoryType = .none
        } else if !completedTasks.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            accessoryType = .none
            content.secondaryText = "0"
        }
        contentConfiguration = content
    }
}


