//
//  ExpenseDataTableViewController.swift
//  SPNDR
//
//  Created by administrator on 29/12/2022.
//

import UIKit

class ExpenseDataTableViewController: UITableViewController {
    var fetchedItem: Item = Item()
    var tempItem: Item = Item()
    
    let lsm = LocalStorageManager()

    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var editBttnOutlet: UIButton!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var doneBttnOutlet: UIButton!
    @IBOutlet weak var cancelBttnOutlet: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //let lsm = LocalStorageManager()
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
        }
        else {
            window.overrideUserInterfaceStyle = .light
        }
        quantityField.text = String(Int(fetchedItem.quantity)) ?? ""
        notesField.text = fetchedItem.notes
        priceField.text = String(fetchedItem.price) ?? ""
        categoryField.text = fetchedItem.itemCategoryRef
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        lsm.saveItem(itemList: Category.itemList)
        
    }
    

    
    @IBAction func editBttn() {
        quantityField.isEnabled = true
        notesField.isEditable = true
        priceField.isEnabled = true
        editBttnOutlet.isHidden = true
        doneBttnOutlet.isHidden = false
        cancelBttnOutlet.isHidden = false
    }
    
    @IBAction func doneBtn()
    {
        func reloadPage()
        {
            quantityField.isEnabled = false
            notesField.isEditable = false
            priceField.isEnabled = false
            editBttnOutlet.isHidden = false
            doneBttnOutlet.isHidden = true
            cancelBttnOutlet.isHidden = true
            quantityField.text = String(fetchedItem.quantity) ?? ""
            notesField.text = fetchedItem.notes
            priceField.text = String(fetchedItem.price) ?? ""
        }
        var changedQuant : Double
        let quanText = quantityField.text
        let priceText = priceField.text
        var priceNum = Double(priceField.text!) ?? 0.0
        var priceNum1 = fetchedItem.price
        var quanNumber1 = fetchedItem.quantity
        var quanNumber3 = Double(quanText ?? "") ?? 0.0
        
        func hasNumber(_ string: String) -> Bool{
            for character in string
            {
                if character.isNumber
                {
                    return true
                }
                
                
            }
            return false
        }
        
        func isInteger(value: Double) -> Bool {
                if value.truncatingRemainder(dividingBy: 1) == 0 {
                    return true
                }
                return false
            }
        
        if  quanText!.isEmpty || priceText!.isEmpty || !hasNumber(priceText!) || quanNumber1 < 1 || !isInteger(value: quanNumber3) {
            let alert = UIAlertController(title: "Something is wrong 💀 " , message:"Please make sure you filled fields with accurate information😭🙏🏿", preferredStyle: .alert)
               self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
                self.quantityField.text = String(self.fetchedItem.quantity) ?? ""
                self.notesField.text = self.fetchedItem.notes
                self.priceField.text = String(self.fetchedItem.price) ?? ""
            }))
        }
        else
        {
            fetchedItem.quantity = Double(quantityField.text!) ?? 0.0
            fetchedItem.price = Double(priceField.text!) ?? 0.0
            fetchedItem.notes = String(notesField.text!) ?? ""
            var quanNumber2 = fetchedItem.quantity
            let lsm = LocalStorageManager()
            var changedPrice = 0.0
            var priceNum2 = lsm.getTotal()
            
            /*
            if priceNum1 > priceNum2
                {
                changedPrice = priceNum1-priceNum2
                CategoryList.totalPrice -= changedPrice*quanNumber2
                lsm.saveTotal(totalExpenses: CategoryList.totalPrice)
                }

            else
                {
                changedPrice = priceNum2-priceNum1
                CategoryList.totalPrice += changedPrice*quanNumber2
                lsm.saveTotal(totalExpenses: CategoryList.totalPrice)

                }

            if quanNumber2 > quanNumber1
                {
                    changedQuant = quanNumber2 - quanNumber1
                    CategoryList.totalPrice += fetchedItem.price*changedQuant
                    lsm.saveTotal(totalExpenses: CategoryList.totalPrice)
                }

            else
                {
                    changedQuant = quanNumber1 - quanNumber2
                    CategoryList.totalPrice -= fetchedItem.price*changedQuant
                    lsm.saveTotal(totalExpenses: CategoryList.totalPrice)

                }
             
*/              var totalExpenses = 0.0
                for item in Category.itemList{
                    totalExpenses += item.price * Double(item.quantity)
                }
            
            lsm.saveTotal(totalExpenses: totalExpenses)
            changedQuant = 0.0
            if priceNum1 != priceNum || quanNumber1 != changedQuant {
                        let priceDiff = (priceNum - priceNum1) * (changedQuant - quanNumber1)
                        changedQuant = quanNumber1 - quanNumber2
                        lsm.updateTotalExpenses(changePrice: priceDiff, changeQuantity: changedQuant)
            }
           reloadPage()
     

            
        }
    }
    
    
    @IBAction func cancelBtn()
    {
        quantityField.isEnabled = false
        notesField.isEditable = false
        priceField.isEnabled = false
        editBttnOutlet.isHidden = false
        doneBttnOutlet.isHidden = true
        cancelBttnOutlet.isHidden = true
        quantityField.text = String(fetchedItem.quantity) ?? ""
        notesField.text = fetchedItem.notes
        priceField.text = String(fetchedItem.price) ?? ""
    }
    
    
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
