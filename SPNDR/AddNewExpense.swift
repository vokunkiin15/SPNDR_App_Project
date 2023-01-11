//
//  AddNewExpense.swift
//  SPNDR
//
//  Created by administrator on 21/12/2022.
//

import UIKit


class AddNewExpense: UIViewController//, UIPickerViewDataSource
{

    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var expenseText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var recordsTable: UITableView!
    
    var sRow: Int = 0
    var catName : String = ""
    var tempArray : [Item] = []
    let lsm = LocalStorageManager()
    var currString = ""

   
//    func sendData() {
       
//    }
    

    
    
    override func viewDidLoad() {
        if LocalStorageManager.getCurrency() == nil {
            currString = "BD"
        }
        else{
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
        }
        else {
            window.overrideUserInterfaceStyle = .light
        }
        super.viewDidLoad()
        picker.selectRow(0, inComponent: 0, animated: true)
        quantityText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        picker.dataSource = self
        picker.delegate = self
        let lsm : LocalStorageManager = LocalStorageManager()
        let decodedItems = lsm.getItem()
        Category.itemList = decodedItems
        recordsTable.delegate = self
        recordsTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var currString : String
        if LocalStorageManager.getCurrency() == nil {
            currString = "BD"
        }
        else {
            currString = LocalStorageManager.getCurrency()!.currencySymbol
        }
        picker.reloadAllComponents()
    }
    
 
    
    @objc func textFieldDidChange(_ textField: UITextField){
        self.stepper.value = Double(textField.text ?? "0") ?? 0.0
    }
    
    
    @IBAction func stepperManager()
    {
        //let number = Double(quantityText.text!)
        quantityText.text = "\(Int(stepper.value))"

    }
    @objc func stepperValueChanged(_ sender: UIStepper) {
        stepper.wraps = true
        stepper.value = round(stepper.value)
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        if sender.value.truncatingRemainder(dividingBy: 1) != 0 {
            sender.value = round(sender.value)
        }
     }
    
    
    
    
    @IBAction func addNewExpenseToArray()
    {
        let exp = expenseText.text ?? ""
        let pric = priceText.text ?? ""
        let quant = quantityText.text ?? ""
        let priceOut = Double(priceText.text!) ?? 0.0
        let quantInt = Double(quantityText.text!) ?? 0.0
        func hasNumber(_ string: String) -> Bool{
            for character in string{
                if character.isNumber{
                    return true
                }
            }
            return false
        }
        if exp.isEmpty || pric.isEmpty ||  quant.isEmpty || quantInt < 1 || sRow == 0 || !hasNumber(pric) || priceOut < 0 {
            let alert = UIAlertController(title: "Something is wrong 💀 " , message:"Please make sure you filled fields with accurate information😭🙏🏿", preferredStyle: .alert)
               self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
                self.recordsTable.reloadData()

            }))
        }
        else {
        let tempItem : Item = Item(expenseName: exp, price: priceOut, quantity: quantInt)
        tempItem.notes = notesText.text
        tempItem.itemCategoryRef = catName
        tempArray.append(tempItem)
        recordsTable.reloadData()
            self.expenseText.text = ""
            self.priceText.text = ""
            self.quantityText.text = "1"
            self.notesText.text = ""
        }
    }
    
    
    @IBAction func doneBtn() {
        var lsm: LocalStorageManager = LocalStorageManager()
        if tempArray.count > 0 {
        for i in 0...tempArray.count - 1
        {
         
//           CategoryList.searchCategory(catName: tempArray[i].itemCategoryRef).itemList.append(tempArray[i])
            CategoryList.totalPrice += tempArray[i].price * tempArray[i].quantity
            Category.itemList.append(tempArray[i])
            Category.itemList[i].id += 1
            lsm.saveTotal(totalExpenses: CategoryList.totalPrice)
         
        }
            lsm.saveItem(itemList: Category.itemList)
            tempArray=[]
           
        
        let alert = UIAlertController(title: "Successfully Added" , message:"Your records has been saved 😭", preferredStyle: .alert)
           self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
            self.recordsTable.reloadData()

        }))
        
        
    }
        else {
            let alert = UIAlertController(title: "You did not add any records" , message:"😭", preferredStyle: .alert)
               self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //guard let textField = alertEmpty?.textFields?[0], let userText = textField.text else { return }
                self.recordsTable.reloadData()
               

            }))
        }
    }
    
}

extension AddNewExpense: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lsm.getCategories().count + 1
        //return CategoryList.categoryCollection.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {

        return row == 0 ? "" : lsm.getCategories()[row - 1].catName
        //return CategoryList.categoryCollection[row].catName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        sRow = row
        var simpA : [String] = [" "]
        for i in 0...lsm.getCategories().count - 1
        {
            simpA.append(lsm.getCategories()[i].catName)
        }
        
        catName = simpA[row]
    }
    
    
    
}

extension AddNewExpense: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete"){ (rowAction, indexPath) in
            self.tempArray.remove(at: indexPath.row)
                       tableView.reloadData()
            
        }
        deleteButton.backgroundColor = UIColor.red
        return[deleteButton]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath)
        let intQuant = Int(tempArray[indexPath.row].quantity)
        let text = "\(tempArray[indexPath.row].expenseName) \(tempArray[indexPath.row].price)\(currString) x\(intQuant)"
        let changedText = NSMutableAttributedString(string: text)
        changedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: (text as NSString).range(of: "\(tempArray[indexPath.row].price)\(currString)"))
        cell.textLabel?.attributedText = changedText
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
}
