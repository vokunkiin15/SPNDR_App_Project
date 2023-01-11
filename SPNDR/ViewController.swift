//
//  ViewController.swift
//  SPNDR
//
//  Created by administrator on 01/11/2022.
//

import UIKit

class ViewController: UIViewController {
    // Login/ Signup stacks
    @IBOutlet weak var LogInStack: UIStackView!
    @IBOutlet weak var SignUpStack: UIStackView!
    
    // login/ signup switch
    @IBOutlet weak var LoginSignupSwitch: UISegmentedControl!
    
    //login stack var
    @IBOutlet weak var loginUsernameTxt: UITextField!
    @IBOutlet weak var loginPassText: UITextField!
    
    //signup stack var
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passWordTxt: UITextField!
    @IBOutlet weak var cPassWordTxt: UITextField!
    
    // the access feedback
    @IBOutlet weak var accessResult: UITextField!
    
    // simple database instance
    var spndrDB = Accounts()
    
    // login/signup setting
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LogInStack.isHidden = false
        SignUpStack.isHidden = true

        spndrDB.addNewUser(userName: "Nasser", passWord: 11111)
        spndrDB.addNewUser(userName: "Mohd", passWord: 11111)
        spndrDB.addNewUser(userName: "Ali", passWord: 11111)
    }

    // signup/ login switchingS
    @IBAction func changeLogSign(_ sender: Any)
    {
        
        switch LoginSignupSwitch.selectedSegmentIndex
        {
            case 0:
                LogInStack.isHidden = false
                SignUpStack.isHidden = true
            case 1:
                LogInStack.isHidden = true
                SignUpStack.isHidden = false
        default:
            break
        }
    }
    
    
    // Login
    @IBAction func LoginBtnClicked(_ sender: Any)
    {
        
        if serchSpndrDB() != nil
        {
            self.performSegue(withIdentifier: "toSPNDR", sender: self)
            accessResult.text = ""
        }
        
        else
        {
            accessResult.text = "ACCESS DENIED 😨, Could not find the user within the database"
        }

    }
    
    // SignUp
    @IBAction func confirmPasswordClicked()
    {
        cPassWordTxt.text = passWordTxt.text
    }
    
    
    @IBAction func SignUpClicked(_ sender: Any)
    {
        
        if let oFirstName = firstNameTxt.text
        {
            if let oLastName = lastNameTxt.text
            {
                if let oEmail = emailTxt.text
                {
                    if let oUserName = userNameTxt.text
                    {
                        if let oPassword = Int(passWordTxt.text!)
                        {
                            
                                    if cPassWordTxt.text == String(oPassword)
                                    {
                                        let nuUser = User(userName: oUserName, passWord: oPassword)
                                        nuUser.email = oEmail
                                        nuUser.lastName = oLastName
                                        nuUser.firstName = oFirstName
                                        if accountDoesExist(user: nuUser)
                                        {
                                            accessResult.text = "\(nuUser.userName) userName and password are already been used in the system, try again with different username and password🤪"
                                        }
                                        else
                                        {
                                            spndrDB.addNewUser(userName: nuUser.userName, passWord: nuUser.passWord)
                                            
                                            changeStack(num: 0)
                                            loginUsernameTxt.text = nuUser.userName
                                            loginPassText.text = String(nuUser.passWord)
                                            accessResult.text = "Welcome to SPNDR application \(nuUser.firstName) 😜✋🏽, please press login"
                                        }
                                        
                                    }
                            else
                            {
                                accessResult.text = "the passwords in password and confirmation password textfield are mismatched, please make sure to click on the c button to confirm your password entry😐🫤😑"
                                return
                            }
                                    

                        }
                        else
                        {
                            accessResult.text = "You have either not entered valid Password or you may have left the field empty 😐"
                        }
                    }
                    else
                    {
                        accessResult.text = "You have either not entered valid userName or you may have left the field empty 😯"
                    }

                }
                else
                {
                    accessResult.text = "You have either not entered valid email or you may have left the field empty 🙄"
                }

            }
            else
            {
                accessResult.text = "You have either not entered valid last name or you may have left the field empty 😢"
            }

            }
        else
        {
            accessResult.text = "You have either not entered valid first name or you may have left the field empty, try again 😔"
        }

        
        
        
    }
    

    // this function will search the array using the entered texts in the text boxes in the login stack
    func serchSpndrDB() -> User?
    {
        let tempPass = Int(loginPassText.text!)
        for i in 0...spndrDB.accountsCollection.count - 1
        {
            if spndrDB.viewAccountsList()[i].userName == loginUsernameTxt.text && spndrDB.viewAccountsList()[i].passWord == tempPass
            {
                return spndrDB.viewAccountsList()[i]
            }
            
        }
        return nil
    }
    
    // this function will change between sign up and login stacks
    func changeStack(num: Int)
    {
        LoginSignupSwitch.selectedSegmentIndex = num
        if LoginSignupSwitch.selectedSegmentIndex == 0
        {
            LogInStack.isHidden = false
            SignUpStack.isHidden = true
        }
        else
        {
            LogInStack.isHidden = true
            SignUpStack.isHidden = false
        }
        
    }
    
    // this function will help in verifying an existing account to stop creating dublicate accounts
    func accountDoesExist(user : User) -> Bool
    {
        for i in 0...spndrDB.viewAccountsList().count - 1
        {
            if spndrDB.viewAccountsList()[i].userName == user.userName && spndrDB.viewAccountsList()[i].passWord == user.passWord
            {
                return true
            }
        }
        return false
    }
    
    
}

