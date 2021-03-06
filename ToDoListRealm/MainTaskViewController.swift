//
//  MainTaskViewController.swift
//  ToDoListRealm
//
//  Created by Tatiana Dmitrieva on 28/08/2021.
//

import RealmSwift

class MainTaskViewController: UIViewController {
    
    private var taskLists: Results<TaskList>!

@IBOutlet weak var mainTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTaskTableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = mainTaskTableView.indexPathForSelectedRow else { return }
        let taskList = taskLists[indexPath.row]
        guard let tasksVC = segue.destination as? TasksTableViewController else { return }
        tasksVC.taskList = taskList
    }
    
    @IBAction func sortedList(_ sender: UISegmentedControl) {
        taskLists = sender.selectedSegmentIndex == 0
            ? taskLists.sorted(byKeyPath: "date")
            : taskLists.sorted(byKeyPath: "name") //сортировка по ключу в нашей модели
        mainTaskTableView.reloadData()
    }
    /* кнопки Edit и Done на навигационной панели, в случае когда используем tableView в связке с tableViewController */
    
    @IBAction func toggleTableEdit(sender: UIBarButtonItem) {
        mainTaskTableView.setEditing(!mainTaskTableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:
                                        (mainTaskTableView.isEditing) ? .done : .edit,
                                         target: self,
                                         action: #selector(toggleTableEdit))
    }
}

extension MainTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTasksCell", for: indexPath)
        
        let taskList = taskLists[indexPath.row]
        cell.configure(with: taskList)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
        UISwipeActionsConfiguration? {
        
        let currentList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList: currentList)
            self.mainTaskTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: currentList) {
                self.mainTaskTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList: currentList)
            self.mainTaskTableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration()
        swipeAction.performsFirstActionWithFullSwipe = false // отменяем полный свайп
        
        return UISwipeActionsConfiguration(actions: [doneAction,editAction,deleteAction])
    }
    // Параметры в функции showAlert не обязательные, если они есть, то мы редактируем запись, если нет параметров, то сохраняем
    
    private func showAlert(with taskList: TaskList? = nil, completion: (()-> Void)? = nil) {
        
        let title = taskList != nil ? "Edit list" : "New List"
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Add new value")
        
        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList: taskList, newValue: newValue)
                completion()
            } else {
                self.save(taskList: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(taskList: String) {
        let taskList = TaskList(value: [taskList])
        StorageManager.shared.saveTask(taskList: taskList)
        let rowIndex = IndexPath(row: taskLists.count - 1, section: 0)
        mainTaskTableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
