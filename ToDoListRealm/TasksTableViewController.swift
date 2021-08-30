//
//  MainTasksListTableViewController.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 28/08/2021.
//

import RealmSwift

class TasksTableViewController: UITableViewController {
    
    var taskList: TaskList!
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = taskList.name
        
        currentTasks = taskList.tasks.filter("isCompleted = false")
        completedTasks = taskList.tasks.filter("isCompleted = true")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content

        return cell
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

extension TasksTableViewController {
    
   private func showAlert() {
    
    let alert = UIAlertController.createAlert(withTitle: "New Task", andMessage: "Add new task")
    
    alert.action { newTask, note in
        self.saveTask(withName: newTask, andNote: note)
    }
    present(alert, animated: true)
        
    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        
        StorageManager.shared.save(task: task, in: taskList)
        let rowIndex = IndexPath(row: currentTasks.count - 1, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
