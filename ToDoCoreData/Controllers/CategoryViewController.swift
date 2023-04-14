//
//  CategoryViewController.swift
//  ToDoCoreData
//
//  Created by Christian Calixto on 13/4/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [CategoryModel]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
    }


    //MARK: TableView DataSoruce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)

        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name

        return cell
    }

    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }

    }
    //MARK: Data Manipulation Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) {[weak self] action in
            guard let self, let text = textField.text, !text.isEmpty else { return }

            let newCategory = CategoryModel(context: self.context)
            newCategory.name = text
            self.categoryArray.append(newCategory)

            self.saveItems()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            print(textField)
        }

        alert.addAction(action)

        present(alert, animated: true)
    }

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<CategoryModel> = CategoryModel.fetchRequest()) {

        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
    }
}
