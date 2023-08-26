//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
//    var itemArray = [Item]()
    var itemArray: Results<Item>?
    var category: Category? {
        didSet{
            loadItems()
        }
    }
    
    let realm = try! Realm()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
//        loadItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Please input the new Item!"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default){ action in
            if let inputTitle = textField.text {
                
                // New Object
//                let newItem = Item(context: self.context)
                let newItem = Item()
                
                newItem.title = inputTitle
//                newItem.parentCategory = self.category
//                self.itemArray.append(newItem)
//                self.saveItems()
                self.addItem(with: newItem)
            }
        }
        
        alert.addAction(action)
        
        view?.window?.rootViewController?.present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item has been added!"
        }

        return cell
    }
}

//MARK: - UITableViewDelegate

extension TodoListViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("データ更新にエラー発生：\(error)")
            }
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 先にデータを削除しないと、エラーが発生します。
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        saveItems()
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("データ削除にエラー発生：\(error)")
            }
            tableView.reloadData()
        }
    }
}

//MARK: - Data-CRUD

extension TodoListViewController {
    /**
     * CoreData 用
     *
    func saveItems(){
        do {
            try self.context.save()
        } catch {
            print("データ登録にエラー発生：\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        do {
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
            
            if let addiontalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addiontalPredicate])
            } else {
                request.predicate = categoryPredicate
            }
            
            itemArray = try context.fetch(request)
        } catch {
            print("データ読込にエラー発生：\(error)")
        }
        tableView.reloadData()
    }
     */
    
    func addItem(with item: Item) {
        if let currentCategory = category {
            do {
                try realm.write {
                    currentCategory.items.append(item)
                }
            } catch {
                print("データ登録にエラー発生：\(error)")
            }
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if (category?.items.count ?? 0) > 0 {
            itemArray = category?.items.sorted(byKeyPath: "title", ascending: true)
        }
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    /**
     * CoreData 用
     *
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: titlePredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
     */
}
