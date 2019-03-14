//
//  LoginSession.swift
//  Koku
//
//  Created by HoangVu on 3/10/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation

class UserSetting {
    static let sharedInstance = UserSetting()
    var currentUser:UserModel?
    var listCountries: [CountryModel] = []
    var listCountriesName: [String] = []
    var listCurrencies: [String: CurrencyModel]? = [:]
    var listCurrenciesModel: [CurrencyModel] = []
    private init() {}
    func saveCurrentUserToUserDefault()
    {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: UserSetting.sharedInstance.currentUser!)
        userDefaults.set(encodedData, forKey: "currentUser")
        userDefaults.synchronize()
    }
    
    func loadCurrentUserFromUserDefault()
    {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: "currentUser") as? Data
        {
            UserSetting.sharedInstance.currentUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UserModel
        }
    }
    
    func saveDataSetting()
    {
        let userDefaults = UserDefaults.standard
        let encodedDataCountry: Data = NSKeyedArchiver.archivedData(withRootObject: UserSetting.sharedInstance.listCountries)
        let encodedDataCurrency: Data = NSKeyedArchiver.archivedData(withRootObject: UserSetting.sharedInstance.listCurrencies!)
        let encodedDataCurrencyModel: Data = NSKeyedArchiver.archivedData(withRootObject: UserSetting.sharedInstance.listCurrenciesModel)
        let encodedDataCountryName: Data = NSKeyedArchiver.archivedData(withRootObject: UserSetting.sharedInstance.listCountriesName)
        userDefaults.set(encodedDataCountry, forKey: "listCountries")
        userDefaults.set(encodedDataCurrency, forKey: "listCurrencies")
        userDefaults.set(encodedDataCurrencyModel, forKey: "listCurrenciesModel")
        userDefaults.set(encodedDataCountryName, forKey: "listCountryName")
        userDefaults.synchronize()
    }
    
    func loadDataSetting()
    {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: "listCountries") as? Data
        {
            UserSetting.sharedInstance.listCountries = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [CountryModel]
        }
        if let decoded  = userDefaults.object(forKey: "listCurrencies") as? Data
        {
            UserSetting.sharedInstance.listCurrencies = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [String : CurrencyModel]
        }
        if let decoded  = userDefaults.object(forKey: "listCurrenciesModel") as? Data
        {
            UserSetting.sharedInstance.listCurrenciesModel = (NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [ CurrencyModel])!
        }
        if let decoded  = userDefaults.object(forKey: "listCountryName") as? Data
        {
            UserSetting.sharedInstance.listCountriesName = (NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [String])!
        }
        
        
    }
}


