//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Huzhy on 2023/08/22.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoryArray: Results<Category>?
    
    let realm = try! Realm()
    
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
                let newCategory = Category()
                
                newCategory.name = inputContext
                newCategory.createDate = Date()
                
                self.addCatagory(with: newCategory)
            }
        }
        
        alert.addAction(action)
        
        view?.window?.rootViewController?.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category has been added!"

        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categoryArray?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let category = categoryArray?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("データ削除にエラー発生：\(error)")
            }
            tableView.reloadData()
        }
    }
}

//MARK: - Data-CRUD

extension CategoryViewController {
    func addCatagory(with category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("データ登録にエラー発生：\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}
