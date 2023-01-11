//
//  CategoryItemsViewController.swift
//  SPNDR
//
//  Created by administrator on 28/12/2022.
//

import UIKit

class CategoryItemsViewController: UIViewController
{
    @IBOutlet weak var totalAmountDisplay: UILabel!
    
    @IBOutlet weak var navItem: UINavigationItem!
    var indexNum: Int = 0
    var currLib = CurrencyLibrary()
    var itemName: String = ""
    var selectedID = 0

    
// this variable will help on catching the category name from the previous table view controller
    var Cat : String = ""
   var catPageArray: [Item] = []
    var currString = ""

    
    
    
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var itemsTable: UITableView!
    
    
    override func viewDidLoad()
    {
       // getArray()
        //let expenseVC = AddNewExpense()
        //var catPageArray = expenseVC.itemArray
        
        
        super.viewDidLoad()
        let lsm = LocalStorageManager()
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
        }
        else {
            window.overrideUserInterfaceStyle = .light
        }
        let decodedItems = lsm.getItem()
        Category.itemList = decodedItems
        totalAmountDisplay.text = String(format: "%.2f" , CategoryList.totalPrice)
        totalAmountDisplay.text = String(format: "%.2f", calcTotalAmounts())
        itemsTable.delegate = self
        itemsTable.dataSource = self
        //testLabel.text = CategoryList.searchCategory(catName: Cat).itemList[0].expenseName
        itemsTable.reloadData()
        if LocalStorageManager.getCurrency() == nil{
            currString = currLib.currencyCollection[CurrencyLibrary.sRow].currencySymbol
        }
        else {
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        self.totalAmountDisplay.text = "\(CategoryList.totalPrice) \(currString)"
        self.totalAmountDisplay.text = "\(self.calcTotalAmounts()) \(currString)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //totalAmountDisplay.text = String(calcTotalAmounts())
        if LocalStorageManager.getCurrency() == nil{
            currString = currLib.currencyCollection[CurrencyLibrary.sRow].currencySymbol
        }
        else {
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        totalAmountDisplay.text = "\(self.calcTotalAmounts()) \(currString)"
        itemsTable.reloadData()
    }
    
    func calcTotalAmounts() -> Double
    {
        var totalExpenses : Double = 0.0
        var price : Double = 0.0
        var quants : Double = 0.0
//        if CategoryList.searchCategory(catName: Cat).itemList.isEmpty
        if Category.itemList.isEmpty
        {
            totalExpenses = 0.0
        }
        else {
//        for i in 0...CategoryList.searchCategory(catName: Cat).itemList.count - 1
            for i in 0...Category.itemList.count - 1
        {
//            quants = CategoryList.searchCategory(catName: Cat).itemList[i].quantity
//            price = CategoryList.searchCategory(catName: Cat).itemList[i].price
                if Category.itemList[i].itemCategoryRef == Cat {
                quants = Category.itemList[i].quantity
                price = Category.itemList[i].price
                    totalExpenses += (price * quants)
                }
        }
        }
        return totalExpenses
    }

}

extension  CategoryItemsViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var correctCount = 0
        let lsm : LocalStorageManager = LocalStorageManager()
        let decodedItems = lsm.getItem()
        if decodedItems.isEmpty {
            return 0
        }
        else {
        for i in 0...decodedItems.count - 1 {
            if decodedItems[i].itemCategoryRef == Cat {
                correctCount += 1
            }
        }
        }
        return correctCount
        //return 1
        //let decodeCat: Category = CategoryList.searchCategory(catName: Cat)
        //return decodeCat.getDecodedItems().count
        //return CategoryList.searchCategory(catName: Cat).itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lsm = LocalStorageManager()
        let cacheItem = lsm.getItem()
        var correctArray : [Item] = []
        let cell = tableView.dequeueReusableCell(withIdentifier: "ci", for: indexPath)
        //cell.textLabel?.text = CategoryList.searchCategory(catName: Cat).getDecodedItems()[indexPath.row].expenseName
        for i in 0...cacheItem.count - 1
        {
            if cacheItem[i].itemCategoryRef ==  Cat
            {
                correctArray.append(cacheItem[i])
            }
        }
        cell.textLabel?.text = correctArray[indexPath.row].expenseName
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        indexNum = indexPath.row
        selectedID = Category.itemList[indexPath.row].id
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        itemName = currentCell.textLabel!.text ?? ""
       self.performSegue(withIdentifier: "toItemData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let lsm = LocalStorageManager()
////        segue.destination.title = CategoryList.searchCategory(catName: Cat).itemList[indexNum].expenseName
//        segue.destination.title = itemName
        let desVC = segue.destination as! ExpenseDataTableViewController
        var breakLoop = false
//        //desVC.fetchedItem = CategoryList.searchCategory(catName: Cat).itemList[indexNum]
        var correctItem : Item? = nil
//        for i in 0..<Category.itemList.count {
//            if Category.itemList[i].ID == selectedItem!.ID {
//                correctItem = Category.itemList[i]
//
//            }
//        while breakLoop == false {
//var i = 0
// if Category.itemList[i].ID == selectedID {
//    correctItem = Category.itemList[i]
//     breakLoop = true
//        }
//            else {
//                i += 1
//            }
//
//        }
        guard let correctItem = lsm.getItem().filter({ $0.id == selectedID }).first else {
            // no item was found
            return
        }
        desVC.fetchedItem = correctItem
    }
        
          
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var lsm = LocalStorageManager()
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete"){ (rowAction, indexPath) in
//            CategoryList.totalPrice -= CategoryList.searchCategory(catName: self.Cat).itemList[indexPath.row].price * CategoryList.searchCategory(catName: self.Cat).itemList[indexPath.row].quantity
//            CategoryList.searchCategory(catName: self.Cat).itemList.remove(at: indexPath.row)
            var decodedList = lsm.getItem()
            CategoryList.totalPrice -= decodedList[indexPath.row].price * decodedList[indexPath.row].quantity
//            Category.itemList.remove(at: indexPath.row)
            decodedList.remove(at: indexPath.row)
            Category.itemList = decodedList
            lsm.saveItem(itemList: Category.itemList)
            lsm.saveTotal(totalExpenses: CategoryList.totalPrice)
            self.totalAmountDisplay.text = String(CategoryList.totalPrice)
            self.totalAmountDisplay.text = String(self.calcTotalAmounts())
            self.itemsTable.reloadData()
        }
        deleteButton.backgroundColor = UIColor.red
        return[deleteButton]
    
    }
    
}
