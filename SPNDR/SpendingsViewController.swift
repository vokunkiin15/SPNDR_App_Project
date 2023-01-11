//
//  SpendingsViewController.swift
//  SPNDR
//
//  Created by administrator on 07/11/2022.
//

import UIKit

class SpendingsViewController: UIViewController {
    var currString = ""
    let lsm = LocalStorageManager()
    @IBOutlet weak var totalExpense: UILabel!
    var currLib = CurrencyLibrary()
    override func viewDidLoad()
    {

        super.viewDidLoad()
        let lsm = LocalStorageManager()
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode()
        {
            window.overrideUserInterfaceStyle = .dark
        }
        else
        {
            window.overrideUserInterfaceStyle = .light
        }
        var totalExpenses = lsm.getTotal()

        CategoryList.totalPrice = totalExpenses
        let cat1 = Category(catName: "entertainment")
        let cat2 = Category(catName: "grocery")
        let cat3 = Category(catName: "clothes")
    
        if LocalStorageManager.getCurrency() == nil{
            currString = "BD"
        }
        else {
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        
        CategoryList.categoryCollection = [cat1, cat2, cat3]

      
        
        if CategoryList.totalPrice < 0
        {
            lsm.saveTotal(totalExpenses: 0)
        }
        else
        {
        totalExpense.text = "\(CategoryList.totalPrice) \(currString)"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        var totalExpenses = lsm.getTotal()
        CategoryList.totalPrice = totalExpenses
        //let currString = currLib.currencyCollection[CurrencyLibrary.sRow].currencySymbol
        if LocalStorageManager.getCurrency() == nil{
            currString = currLib.currencyCollection[CurrencyLibrary.sRow].currencySymbol
        }
        else {
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        super.viewDidAppear(true)
        
        if CategoryList.totalPrice < 0
        {
            lsm.saveTotal(totalExpenses: 0)
        }
        else
        {
            totalExpense.text = "\(CategoryList.totalPrice) \(currString)"
        }
    }
    
    
    
    

    
}
