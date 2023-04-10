//
//  TodoListViewController.swift
//  ToDoCoreData
//
//  Created by Christian Calixto on 10/4/23.
//

import UIKit

class TodoListViewController: UITableViewController {
    let itemArray = ["Find Mike", "uy Eggs", "Destory Domoforgon"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
}
