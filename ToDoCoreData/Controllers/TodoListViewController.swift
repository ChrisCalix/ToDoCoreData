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

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath)

        let newItem = Item(title: "Find Mike", done: false)
        itemArray.append(newItem)

        let newItem1 = Item(title: "Find Tom", done: false)
        itemArray.append(newItem1)

        let newItem2 = Item(title: "Find Tommy", done: false)
        itemArray.append(newItem2)

        self.loadItems()

    }

    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.itemArray = try decoder.decode([Item].self, from: data)
            } catch {

            }
        }
    }
}

extension TodoListViewController {
    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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

        self.saveItems()
        
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



            self.saveItems()

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

    func saveItems() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
    }
}
