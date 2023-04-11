//
//  TodoListViewController.swift
//  ToDoCoreData
//
//  Created by Christian Calixto on 10/4/23.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "buy Eggs", "Destory Domoforgon"]

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let itemArray = defaults.array(forKey: "TodoListArray") as? [String], !itemArray.isEmpty else { return }
        self.itemArray = itemArray

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

    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = (cell.accessoryType == .none) ? .checkmark : .none

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add new items

    @IBAction func addButtonPressed(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            guard let self, let text = textField.text, !text.isEmpty else { return }
            self.itemArray.append(text)

            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            print(textField)
        }

        alert.addAction(action)

        present(alert, animated: true)
    }
}

