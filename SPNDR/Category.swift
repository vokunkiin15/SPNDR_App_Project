//
//  Category.swift
//  SPNDR
//
//  Created by administrator on 01/11/2022.
//

import Foundation

class CategoryList: Codable
{
    static var categoryCollection : [Category] = []
    static var totalPrice: Double = 0.0
    
    init()
    {
        
    }
    
    static func addToCategoryCollection(category : Category)
    {
        categoryCollection.append(category)
    }
    
    static func deleteFromCategoryList(catName: String)
    {
        for i in 0...categoryCollection.count - 1
        {
            if categoryCollection[i].catName == catName
            {
                categoryCollection.remove(at: i)
            }
        }
    }
    
    static func categoryList() -> [Category]
    {
        return categoryCollection
    }
    
    
    static func searchCategory(catName : String) -> Category
    {
        let fictionCat = Category(catName: "")
        for i in 0 ... categoryCollection.count - 1
        {
            if categoryCollection[i].catName == catName
            {
                return categoryCollection[i]
            }
            
        }
        return fictionCat
    }
 
    
    
    
}

class Category: NSObject, Codable, NSCoding
{
  
    
    var catName: String = ""
    static var itemList: [Item] = []
    var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    init(catName: String)
    {
        self.catName = catName
    }
    
    static func addNewItem(expenseName: String, price: Double, quantity: Double, notes: String)
    {
        let newItem = Item(expenseName: expenseName, price: price, quantity: quantity)
        newItem.notes = notes
        itemList.append(newItem)

    }
    
    func encodeItems(iList: [Item]){
        let archiveURL = documentsDirectory.appendingPathComponent("items_list").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedItem = try? propertyListEncoder.encode(iList)
        try? encodedItem?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func getDecodedItems() -> [Item] {
    let archiveURL = documentsDirectory.appendingPathComponent("items_list").appendingPathExtension("plist")
    let propertyListDecoder = PropertyListDecoder()
        if let retrievedItems = try? Data(contentsOf: archiveURL),
            let decodedItems = try?
            propertyListDecoder.decode(Array<Item>.self, from: retrievedItems) {
            return decodedItems
        }
        return getDecodedItems()
    }
     func encode(with aCoder: NSCoder) {
        aCoder.encode(catName, forKey: "catName")
         aCoder.encode(Category.itemList, forKey: "itemList")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let catName = aDecoder.decodeObject(forKey: "catName") as! String
        let itemList = aDecoder.decodeObject(forKey: "itemList") as! Item
        self.init(catName: "catName")
    }
    
   static func getItemList() -> [Item]
    {
        return itemList
    }
    
   static func searchItem(expenseName: String) -> Item
    {
        let fictionItem = Item(expenseName: "", price: 0, quantity: 0)
        for i in 0 ... itemList.count - 1
        {
            if itemList[i].expenseName == expenseName
            {
                return itemList[i]
            }
            
        }
        return fictionItem
    }
}
    
    
class Item: Codable {
    var expenseName: String
    var price: Double
    var quantity: Double
    var notes: String
    var itemCategoryRef: String
    var id: Int

    private static var ID = 0

    init() {
        self.id = Item.getUniqueID()
        expenseName = " "
        price = 0
        quantity = 0
        notes = " "
        itemCategoryRef = ""
    }

    init(expenseName: String, price: Double, quantity: Double) {
        self.id = Item.getUniqueID()
        self.expenseName = expenseName
        self.price = price
        self.quantity = quantity
        notes = " "
        itemCategoryRef = ""
    }

    private static func getUniqueID() -> Int {
        ID += 1
        return Int.random(in: 100...1000000) + ID
    }
}

class LocalStorageManager
{
    public func saveItem(itemList: [Item])
    {
        do
        {
            let jsonEncoder = JSONEncoder()
            let jsonData = try
            jsonEncoder.encode(itemList)
            let json = String(data: jsonData, encoding: .utf8) ?? "{}"
            
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(json, forKey: "listItem")
            defaults.synchronize()
            Category.itemList = []
            Category.itemList = itemList
        }
        catch
        {
            print(error.localizedDescription)
            
        }
        
        
    }
    
    public func getItem() -> [Item]
    {
        do{
            if (UserDefaults.standard.object(forKey: "listItem") == nil){
                return [Item]()
            } else{
                let json = UserDefaults.standard.string(forKey: "listItem") ?? "{}"
                let jsonDecoder = JSONDecoder()
                guard let jsonData = json.data(using: .utf8) else {
                    return [Item]()
                }
                let listItem: [Item] = try jsonDecoder.decode([Item].self, from: jsonData)
                return listItem
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        return [Item]()
        
    }
    
    public func saveCategory(categoryList: [Category])
    {
        do
        {
            let jsonEncoder = JSONEncoder()
            let jsonData = try
            jsonEncoder.encode(categoryList)
            let json = String(data: jsonData, encoding: .utf8) ?? "{}"
            
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(json, forKey: "listCategory")
            defaults.synchronize()

        }
        catch
        {
            print(error.localizedDescription)
            
        }
    }
    
    public func getCategories() -> [Category]
    {
        do
        {
            if (UserDefaults.standard.object(forKey: "listCategory") == nil)
                {
                    return [Category]()
                }
            
            else
                {
                    let json = UserDefaults.standard.string(forKey: "listCategory") ?? "{}"
                    let jsonDecoder = JSONDecoder()
                    guard let jsonData = json.data(using: .utf8) else
                    {
                        return [Category]()
                    }
                
                let listCategory: [Category] = try jsonDecoder.decode([Category].self, from: jsonData)
                return listCategory
                }
        }
        
        catch
            {
                print(error.localizedDescription)
            }
        
        return [Category]()
        
        
    }
    
    
    public func saveTotal(totalExpenses : Double) {
        let defaults = UserDefaults.standard
        defaults.set(totalExpenses, forKey: "totalExpenses")
        defaults.synchronize()
    }
    
    public func getTotal() -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: "totalExpenses")
    }
    public func updateTotalExpenses(changePrice: Double, changeQuantity: Double) {
           var totalExpenses = getTotal()
           totalExpenses = totalExpenses - (changeQuantity*changePrice)
    }

    
    func saveDarkMode(isDarkMode: Bool) {
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(isDarkMode, forKey: "darkMode")
            defaults.synchronize()
        }

        func getDarkMode() -> Bool {
            return UserDefaults.standard.bool(forKey: "darkMode")
        }

//        func saveCurrency(currency: Currency?)
//        {
//            let defaults: UserDefaults = UserDefaults.standard
//            defaults.set(currency, forKey: "currency")
//            defaults.synchronize()
//        }
//
//        func getCurrency() -> Currency
//        {
//            return UserDefaults.standard.Currency(forKey: "currency")
//        }

    static func saveCurrency(currency: Currency) {
            do {
                let jsonEncoder = JSONEncoder()
                let encodedCurrency = try jsonEncoder.encode(currency)
                let encodedCurrencyString = String(data: encodedCurrency, encoding: .utf8)
                UserDefaults.standard.set(encodedCurrencyString, forKey: "currency")
            } catch {
                print("Error while trying to encode Currency")
            }
        }

        static func getCurrency() -> Currency? {
            guard let encodedCurrencyString = UserDefaults.standard.string(forKey: "currency") else {
                return nil
            }

            do {
                let jsonDecoder = JSONDecoder()
                guard let encodedCurrency = encodedCurrencyString.data(using: .utf8) else {
                    return nil
                }
                let currency = try jsonDecoder.decode(Currency.self, from: encodedCurrency)
                return currency
            } catch {
                print("Error while trying to decode Currency")
                return nil
            }
        }

        func saveName(name: String?) {
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(name, forKey: "name")
            defaults.synchronize()
        }

        func getName() -> String {
            return UserDefaults.standard.string(forKey: "name") ?? ""
        }

    

    
    
    
}

