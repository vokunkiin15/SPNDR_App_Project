//
//  SettingsTableViewController.swift
//  SPNDR
//
//  Created by administrator on 21/12/2022.
//
import LocalAuthentication
import UIKit

class SettingsTableViewController: UITableViewController
{
    let lsm = LocalStorageManager()
    var currLib = CurrencyLibrary()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
       
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lsm.getName() == "" {
            nameLblS1.text = "Guest"
        }
        else {
            nameLblS1.text = lsm.getName()
        }
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
            darkSwitch.isOn = true
        }
        else {
            window.overrideUserInterfaceStyle = .light
            darkSwitch.isOn = true


        }
        
        picker.delegate = self
        picker.dataSource = self
        darkSwitch.isOn = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if lsm.getName() == "" {
            nameLblS1.text = "Guest"
        }
        else {
            nameLblS1.text = lsm.getName()
        }
        nameLblS1.text = lsm.getName()
        let window = UIApplication.shared.windows[0]
        if lsm.getDarkMode() {
            window.overrideUserInterfaceStyle = .dark
            darkSwitch.isOn = true
            dmText.text = "Light Mode 👰🏻‍♂️"
        }
        else {
            window.overrideUserInterfaceStyle = .light
            dmText.text = "Dark Mode 🥷🏿"

            darkSwitch.isOn = false


        }
    }
    // section 1
    @IBOutlet weak var nameLblS1: UILabel!
    
    
    @IBOutlet weak var dmText: UILabel!
    // section 2
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var doneBttn: UIButton!
    @IBAction func changeName() {
        if nameField.text == "" {
            nameLblS1.text = "Guest"
            lsm.saveName(name: nameLblS1.text)
        }
        else {
        nameLblS1.text = nameField.text
        lsm.saveName(name: nameLblS1.text)
        }
    }
    
   
    @IBAction func valueChanged(_ sender: Any) {
        if darkSwitch.isOn == true{
            let window = UIApplication.shared.windows[0]
            window.overrideUserInterfaceStyle = .dark
            dmText.text = "Light Mode 👰🏻‍♂️"
            lsm.saveDarkMode(isDarkMode: true)
            
        }else {
            let window = UIApplication.shared.windows[0]
            window.overrideUserInterfaceStyle = .light
            dmText.text = "Dark Mode 🥷🏿"
            lsm.saveDarkMode(isDarkMode: false)

            
        }
    }

    @IBAction func faceIdBtnClicked(_ sender: Any)
    {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else{
                        let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    let alert = UIAlertController(title: "Finished", message: "FaceID has been set up!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                    self?.present(alert, animated: true)
//                    let vc = UIViewController()
//                    vc.title = "Welcome!"
//                    vc.view.backgroundColor = .systemBlue
//                    self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }}}
            else{
                let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
                }
    }

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource
{

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return self.currLib.currencyCollection.count
        //return CategoryList.categoryCollection.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {

          let row = self.currLib.currencyCollection[row].currencyName
          return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let cLib = CurrencyLibrary()
        CurrencyLibrary.sRow = row
        LocalStorageManager.saveCurrency(currency: cLib.currencyCollection[row])
//        if currLib.currencyCollection[row].currencySymbol == "BD"
//        {
//            CategoryList.totalPrice = currLib.currencyChangerFromBD(CS: currLib.currencyCollection[row].currencySymbol, amount: CategoryList.totalPrice)
//
//        }
//        else
//        {
//            CategoryList.totalPrice = currLib.currencyChangerToBD(CS: currLib.currencyCollection[row].currencySymbol, amount: CategoryList.totalPrice)
//            CategoryList.totalPrice = currLib.currencyChangerFromBD(CS: currLib.currencyCollection[row].currencySymbol, amount: CategoryList.totalPrice)
//
//        }
        //currLib.currencyCollection.swapAt(row, 0)

    }
    
    
}
    
    
    // section 3
    
    
    
    // section 4
    
  
    
    // section 5
    
    //override func viewDidLoad() {
        //super.viewDidLoad()
        
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "textName")
        // createDataSource()
        //tableView.delegate = self
        //tableView.dataSource = self
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    //}
    
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
     */
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
     */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textName", for: indexPath)
        
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


    func loadCurrencyMenu()
    {
        
    }
    
    

//}

