//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Huzhy on 2023/08/22.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Please input the new category!"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default){ action in
            if let inputContext = textField.text {
                
                // New Object
                let newCategory = Category(context: self.context)
                
                newCategory.name = inputContext
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        
        alert.addAction(action)
        
        view?.window?.rootViewController?.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name

        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 先にデータを削除しないと、エラーが発生します。
        context.delete(categoryArray[indexPath.row])
        categoryArray.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveCategories()
    }
}

//MARK: - Data-CRUD

extension CategoryViewController {
    func saveCategories(){
        do {
            try self.context.save()
        } catch {
            print("データ登録にエラー発生：\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("データ読込にエラー発生：\(error)")
        }
        tableView.reloadData()
    }
}
