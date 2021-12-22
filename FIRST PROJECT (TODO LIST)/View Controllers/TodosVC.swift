//
//  TodosVC.swift
//  FIRST PROJECT (TODO LIST)
//
//  Created by يعرُب on 23/04/1443 AH.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray:[Todo] = [
    ]
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        self.todosArray = TodoStorage.getTodos()
        
        super.viewDidLoad()
//        var m = Math()
        
//        do {
//            var r = try m.divide(num1: 40, num2: 10)
//            print(r)
//        }catch {
//            let alert = UIAlertController(title: "error", message: "can't divide by zero", preferredStyle: .alert)
//            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
        
        
        
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // Edit Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // Delete Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil)
        todosTableView.dataSource = self
        todosTableView.delegate = self
    }
    
    @objc func newTodoAdded(notification: Notification){
        
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo {
            todosArray.append(myTodo)
            todosTableView.reloadData()
            TodoStorage.storeTodo(todo: myTodo)
        }
    }
    
    @objc func currentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int {
                todosArray[index] = todo
                todosTableView.reloadData()
                TodoStorage.updateTodo(todo: todo, index: index)
            }
        }
    }
    
    @objc func todoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int {
            
            todosArray.remove(at: index)
            todosTableView.reloadData()
            TodoStorage.deleteTodo(index: index)
            
            
        }
    }
    


    
}

extension TodosVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitleLabel.text = todosArray[indexPath.row].title
        
        if todosArray[indexPath.row].image != nil {
            cell.todoImageView.image = todosArray[indexPath.row].image
        }else {
            cell.todoImageView.image = UIImage(named: "Image-4")
        }
        
        cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 2
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todosArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? TodoDetailsVC
        
        if let viewController = vc {
            viewController.todo = todo
            viewController.index = indexPath.row
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
    
    
    
}
