//
//  CategoriesTableViewController.swift
//  SPNDR
//
//  Created by administrator on 25/12/2022.
//

import UIKit

class CategoriesTableViewController: UITableViewController
{
    var indexNum : Int = 0
    var lsm = LocalStorageManager()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
        }
        else {
            window.overrideUserInterfaceStyle = .light
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lsm.getCategories().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = lsm.getCategories()[indexPath.row].catName.lowercased()
//        cell.textLabel?.text = CategoryList.categoryCollection[indexPath.row].catName.lowercased()
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.catlist.categoryCollection.remove(at: indexPath.row)
//            self.tableView.reloadData()
//
//
//
//
//
//            // Delete the row from the data source
//            /*tableView.deleteRows(at: [indexPath], with: .fade)*/
//        }
        /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   */
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       indexNum = indexPath.row
       self.performSegue(withIdentifier: "toCategoryItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        segue.destination.title = lsm.getCategories()[indexNum].catName
        let desVC = segue.destination as! CategoryItemsViewController
        desVC.Cat = lsm.getCategories()[indexNum].catName
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let alertController = UIAlertController(title: "Change Category", message: nil, preferredStyle: .alert)
//        alertController.addTextField()
//
        let editButton = UITableViewRowAction(style: .normal, title: "Edit Name"){ (rowAction, indexPath) in
            
//            if let textField = alertController.textFields?.first{
                
               //self.catlist.categoryCollection[indexPath.row].catName = textField.text ?? "No category"
//            self.performSegue(withIdentifier: "toCategoryItems", sender: self)
//                self.tableView.reloadData()
        
            
//            self.performSegue(withIdentifier: "toCategoryChanger", sender: self.catlist.categoryCollection[indexPath.row].catName)
//
//                       self.tableView.reloadData()
            let textname = CategoryList.categoryCollection[indexPath.row].catName
            let alert = UIAlertController(title: textname , message: "What would you like to change the name to?", preferredStyle: .alert)
               self.present(alert, animated: true, completion: nil)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Change Category Name"
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                // same action addNewCat
                

                    
                    var found: Bool = false
                    var i : Int = 0
                    repeat
                    {
                        if userText.lowercased() == CategoryList.categoryCollection[i].catName.lowercased()
                        {
                          
                            found = true
                           

                        }
                        else
                        {
                        
                            
                            found = false
                        }
                        
                        i = i + 1
                        
                    }
                    while !found && i < CategoryList.categoryCollection.count
                            
                            if found
                    {
                            let alert2 = UIAlertController(title: "\(userText) already exists", message: "please call it something else", preferredStyle: .alert)
                               self.present(alert2, animated: true, completion: nil)
                            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert2] (_) in
                            //guard let textField = alert2?.textFields?[0], let userText = textField.text else { return }
                            self.tableView.reloadData()
                        }))

                    }
                    else if userText.isEmpty
                    {
                        
                            let alertEmpty = UIAlertController(title: "Text is empty 🫤", message: "please enter some text", preferredStyle: .alert)
                               self.present(alertEmpty, animated: true, completion: nil)
                        alertEmpty.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertEmpty] (_) in
                            //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
                            self.tableView.reloadData()

                        }))
                            
                        }
                        
                    else
                    {
                        CategoryList.categoryCollection[indexPath.row].catName = userText
                        self.lsm.saveCategory(categoryList: CategoryList.categoryCollection)
                    }
                    
                    self.tableView.reloadData()
                    

                
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                    //guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                    self.tableView.reloadData()
                    

                
                }))
                //
                
                self.tableView.reloadData()
                

            
        
            
            /*alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
                self.tableView.reloadData()
                

            
            }))*/
            
            
            
            
            }
        
        
            
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete"){ (rowAction, indexPath) in
            CategoryList.categoryCollection.remove(at: indexPath.row)
            self.lsm.saveCategory(categoryList: CategoryList.categoryCollection)
            self.tableView.reloadData()
            
        }
        deleteButton.backgroundColor = UIColor.red
        return[editButton, deleteButton]
    }
    
    
    @IBAction func addNewCat(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new Category", message: "What do you want your new category to be called?", preferredStyle: .alert)
           self.present(alert, animated: true, completion: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category Name"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            let catEX = Category(catName: userText)
            var found: Bool = false
            var i : Int = 0
            repeat
            {
                if userText.lowercased() == CategoryList.categoryCollection[i].catName.lowercased()
                {
                  
                    found = true
                   

                }
                else
                {
                
                    
                    found = false
                }
                
                i = i + 1
                
            }
            while !found && i < CategoryList.categoryCollection.count
                    
                    if found
            {
                    let alert2 = UIAlertController(title: "\(userText) already exists", message: "please call it something else", preferredStyle: .alert)
                       self.present(alert2, animated: true, completion: nil)
                
                    alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert2] (_) in
                    //guard let textField = alert2?.textFields?[0], let userText = textField.text else { return }
                    self.tableView.reloadData()
 
                
                }))
                
                
            }
            else if userText.isEmpty
            {
                
                    let alertEmpty = UIAlertController(title: "Empty String 🫤", message: "please enter some text", preferredStyle: .alert)
                       self.present(alertEmpty, animated: true, completion: nil)
                alertEmpty.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertEmpty] (_) in
                    //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
                    self.tableView.reloadData()

                }))
                    
                }
                
            else
            {
                    CategoryList.addToCategoryCollection(category: catEX)
                self.lsm.saveCategory(categoryList: CategoryList.categoryCollection)
            }
            
                    
            
            
            self.tableView.reloadData()
            

        
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            //guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            self.tableView.reloadData()
            

        
        }))
        
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
