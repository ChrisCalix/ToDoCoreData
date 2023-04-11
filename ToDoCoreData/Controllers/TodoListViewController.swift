//
//  TodoListViewController.swift
//  ToDoCoreData
//
//  Created by Christian Calixto on 10/4/23.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item(title: "Find Mike", done: false)
        itemArray.append(newItem)

        let newItem1 = Item(title: "Find Tom", done: false)
        itemArray.append(newItem1)

        let newItem2 = Item(title: "Find Tommy", done: false)
        itemArray.append(newItem2)

//        if let items = defaults.array(forKey: "TodoListArray2") as? [Item] {
//            itemArray = items
//        }

        // Retrieve from UserDefaults
        if let data = defaults.object(forKey: "TodoListArray2") as? Data,
           let items = try? JSONDecoder().decode([Item].self, from: data) {
            itemArray = items
        }

    }
}

extension TodoListViewController {
    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("CellForRowAtIndexPath Called")

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
}

extension TodoListViewController {
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done.toggle()

//        tableView.reloadData()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add new items

    @IBAction func addButtonPressed(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            guard let self, let text = textField.text, !text.isEmpty else { return }

            var newItem = Item(title: text, done: false)
            newItem.title = text
            self.itemArray.append(newItem)

            // To store in UserDefaults
            if let encodedItem = try? JSONEncoder().encode(self.itemArray) {
                self.defaults.set(encodedItem, forKey: "TodoListArray2")
            }

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
