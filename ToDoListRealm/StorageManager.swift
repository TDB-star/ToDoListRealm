//
//  StorageManager.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 28/08/2021.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try!Realm()
    
    private init() {}
    
    // MARK: Work with taskLists
    func save(taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
   
    func saveTask(taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func delete(taskList: TaskList) {
        write {
            realm.delete(taskList.tasks) // удаляем все задачи
            realm.delete(taskList) // удаляем лист с задачами
        }
    }
    
    // MARK: Work with tasks
    
    func save(task: Task, in taskList: TaskList) {
        write {
            taskList.tasks.append(task) // в список добавляем задачу
        }
    }
    
    private func write(_ completion: () -> Void) {
        
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
        
    }
}
