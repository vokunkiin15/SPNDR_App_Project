//
//  LogIn.swift
//  SPNDR
//
//  Created by administrator on 02/11/2022.
//

import Foundation

class Accounts
{
    var accountsCollection : [User]
    
    init()
    {
        accountsCollection = []
    }
    
    func addNewUser(userName: String, passWord: Int)
    {
        let newUser = User(userName: userName, passWord: passWord)
        accountsCollection.append(newUser)
    }
    
    func viewAccountsList() -> [User]
    {
        return accountsCollection
    }
    
}

class User
{
    var userName: String
    var passWord: Int
    var userID: Int = 0
    static var userIdSeq: Int = 1
    var spendingCategories: CategoryList
    
    var firstName: String
    var lastName: String
    var email: String
    
    init(userName: String, passWord: Int)
    {
        self.userName = userName
        self.passWord = passWord
        userID = userID + User.userIdSeq
        
        firstName = ""
        lastName = ""
        email = ""
        
        spendingCategories = CategoryList() 
    }
    
    func viewSpendingList() -> CategoryList
    {
        return spendingCategories
    }
    
}

