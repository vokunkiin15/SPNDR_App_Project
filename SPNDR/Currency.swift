//
//  Currency.swift
//  SPNDR
//
//  Created by administrator on 20/12/2022.
//

import Foundation

class Currency: Codable
 {
     var currencyName : String
     var currencySymbol : String
 
     init(currencyName: String, currencySymbol: String) {
         self.currencyName = currencyName
         self.currencySymbol = currencySymbol
     }
     
 }
 
 class CurrencyLibrary
 {
  var currencyCollection : [Currency]
     static var sRow : Int = 0
 
 init()
     {
         let currency1 = Currency(currencyName: "Bahraini Dinar", currencySymbol: "BD")
         let currency2 = Currency(currencyName: "Saudi Riyal", currencySymbol: "SR")
         let currency3 = Currency(currencyName: "Kuwaiti Dinar", currencySymbol: "KD")
         let currency4 = Currency(currencyName: "Emirati Dirham", currencySymbol: "AD")
         let currency5 = Currency(currencyName: "Qatari Riyal", currencySymbol: "QR")
         let currency6 = Currency(currencyName: "United States Dollars", currencySymbol: "$")
             
         currencyCollection = [currency1,
                                               currency2,
                                               currency3,
                                               currency4,
                                               currency5,
                                               currency6]

     }
     
     func currencyChangerFromBD(CS : String, amount : Double) -> Double
     {
         var result : Double = 0
         if CS == "$"
         {
             result = amount * 2.65
         }
         else if CS == "SR" || CS == "AD" || CS == "QR"
         {
             result = amount * 10
         }
         else if CS == "KD"
         {
             result = amount * 0.81
         }
         return result
     }
     
     func currencyChangerToBD(CS: String, amount : Double) -> Double
     {
         var result : Double = 0
         if CS == "$"
         {
             result = amount / 2.65
         }
         else if CS == "SR" || CS == "AD" || CS == "QR"
         {
             result = amount / 10
         }
         else if CS == "KD"
         {
             result = amount / 0.81
         }
         return result
     }
 }


/*
 CURRENCY TRANSFORM
 
 FROM BD TO USD (VICE VERSA)
 1 BD -> 2.65 USD
 SO
 USD = BD * 2.65
 BD = USD / 2.65
 
 FROM BD TO SR
 1 BD -> 10 SR
 SO
 SR = BD * 10
 BD = SR / 10
 
 FROM BD TO KD
 1 BD -> 0.81 KD
 SO
 KD = BD * 0.81
 BD = KD / 0.81
 
 FROM BD TO AD
 1 BD -> 10 AD
 SO
 AD = BD * 10
 BD = AD / 10
 
 FROM BD TO QR
 1 BD -> 10 QR
 QR = BD * 10
 BD = QR / 10
 

 */
