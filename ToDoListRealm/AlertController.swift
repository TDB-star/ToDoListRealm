//
//  AlertController.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 30/08/2021.
//

import UIKit

extension UIAlertController {
    
    static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert) }
    
    func action(with taskList: TaskList?, completion: @escaping(String) -> Void){
        
        let doneButton = taskList == nil ? "Save" : "Update"
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "List name"
            textField.text = taskList?.name
        }
    }
    
    func action(with task: Task?, completion: @escaping(String, String) -> Void) {
        
        let title = task == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: title, style: .default) { _ in
            guard let newtask = self.textFields?.first?.text else { return }
            guard !newtask.isEmpty else {return}
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(newtask, note)
            }
            else {
                completion(newtask, "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = task?.name
        }
        addTextField { textField in
            textField.placeholder = "Note"
            textField.text = task?.note
        }
    }
}


