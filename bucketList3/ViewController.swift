//
//  ViewController.swift
//  bucketList3
//
//  Created by Christopher Chung on 7/10/18.
//  Copyright © 2018 Christopher Chung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tableData: [Task] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchAllTasks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchAllTasks(){
        let request:NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tableData = try context.fetch(request)
        } catch {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToViewController(segue: UIStoryboardSegue){
        let src = segue.source as! AddItemVC
        let text = src.textField.text!
        print(text)
        if let indexPath = src.indexPath {
            //If indexPath is there
            print("in IF LET INDEXPATH", indexPath.row, "with text", text)
            tableData[indexPath.row].title = text
            appDelegate.saveContext()
            tableView.reloadData()
            // Updates table data at indexPath.row
        } else {
            print("in ELSE STATEMENT")
            let newTask = Task(context: context)
            newTask.title = text
            newTask.created_at = Date()
            appDelegate.saveContext()
            //Pull text out of source
            tableData.append(newTask)
            // Append to Table Data
            tableView.reloadData()
        }
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEditSegue", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            print("Came from cell")
            let text = tableData[indexPath.row]
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddItemVC
            //TOP VIEW CONTROLLER IS THE CONTROLLER NAV IS DIRECTLY POINTING TO. I.E. THE ONE ON TOP
            //NEXT YOU NEED TO SET SOMETHING IN DESTINATION
            dest.item = text.title!
            print("indexPath in prepare function", indexPath)
            dest.indexPath = indexPath
        } else {
            print("Came from bar button")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].title
        return cell
    }
    // DID SELECT ROW AT IS PART OF UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, bool) in
            self.context.delete(self.tableData[indexPath.row])
            self.tableData.remove(at: indexPath.row)
            self.appDelegate.saveContext()
            tableView.reloadData()
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig

    }
}


