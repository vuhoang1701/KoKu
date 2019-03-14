//
//  CountryModel.swift
//  Koku
//
//  Created by HoangVu on 3/11/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation
class CountryModel : NSObject, NSCoding {
    
    var id: String
    var name: String
    var alpha3: String
    var currencyId: String
    var currencyName: String
    var currencySymbol: String

    init(id: String, name: String, alpha3: String , currencyid: String , currencyname: String, currencysymbol: String) {
        self.id = id
        self.name = name
        self.alpha3 = alpha3
        self.currencyId = currencyid
        self.currencyName = currencyname
        self.currencySymbol = currencysymbol
       
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let alpha3 = aDecoder.decodeObject(forKey: "alpha3") as! String
        let currencyId = aDecoder.decodeObject(forKey: "currencyId") as! String
        let currencyName = aDecoder.decodeObject(forKey: "currencyName") as! String
        let currencySymbol = aDecoder.decodeObject(forKey: "currencySymbol") as! String
        self.init(id: id, name: name, alpha3: alpha3, currencyid: currencyId, currencyname: currencyName, currencysymbol: currencySymbol)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(alpha3, forKey: "alpha3")
        aCoder.encode(currencyId, forKey: "currencyId")
        aCoder.encode(currencyName, forKey: "currencyName")
        aCoder.encode(currencySymbol, forKey: "currencySymbol")
    }
    
}
