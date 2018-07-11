//
//  ViewController.swift
//  bucketList3
//
//  Created by Christopher Chung on 7/10/18.
//  Copyright © 2018 Christopher Chung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableData: [String] = ["Test", "Test2"]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
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
            tableData[indexPath.row] = text
            tableView.reloadData()
            // Updates table data at indexPath.row
        } else {
            print("in ELSE STATEMENT")
            //Pull text out of source
            tableData.append(text)
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
            dest.item = text
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
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    // DID SELECT ROW AT IS PART OF UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, bool) in
            self.tableData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig

    }
}


