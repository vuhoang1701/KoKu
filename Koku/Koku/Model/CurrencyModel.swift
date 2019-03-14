//
//  CountryModel.swift
//  Koku
//
//  Created by HoangVu on 3/11/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation
class CurrencyModel : NSObject, NSCoding {
    
    var id: String
    var currencyName: String
    var currencySymbol: String
    var countryName: String
    var countryCode: String
    
    init(id: String , currencyname: String, currencysymbol: String, countryname: String, countrycode: String) {
        
        self.id = id
        self.currencyName = currencyname
        self.currencySymbol = currencysymbol
        self.countryName = countryname
        self.countryCode = countrycode
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let currencyName = aDecoder.decodeObject(forKey: "currencyName") as! String
        let currencySymbol = aDecoder.decodeObject(forKey: "currencySymbol") as! String
        let countryName = aDecoder.decodeObject(forKey: "countryName") as! String
        let countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String
        self.init(id: id, currencyname: currencyName, currencysymbol: currencySymbol, countryname: countryName, countrycode: countryCode)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(currencyName, forKey: "currencyName")
        aCoder.encode(currencySymbol, forKey: "currencySymbol")
        aCoder.encode(countryName, forKey: "countryName")
        aCoder.encode(countryCode, forKey: "countryCode")
    }
    
}
