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
    
    func action(completion: @escaping(String) -> Void){
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "List name"
        }
    }
    
    func action(completion: @escaping(String, String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
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
        }
        addTextField { textField in
            textField.placeholder = "Note"
        }
    }
}


