//
//  AppDelegate.swift
//  Update Activity
//
//  Created by HoangVu on 3/15/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let sharedInstance = UIApplication.shared.delegate as? AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UserSetting.sharedInstance.loadDataSetting()
        if(UserSetting.sharedInstance.listCountries == [] || UserSetting.sharedInstance.listCurrencies == [:])
        {
            AppDelegate.sharedInstance?.getListCountries()
            AppDelegate.sharedInstance?.getListCurrencies()
        }
        SocketIOManager.sharedInstance.establishConnection {
            let userInfo = ["customId": "999"]
            SocketIOManager.sharedInstance.socket.emit("storeClientInfo",userInfo)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Update_Activity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //Initial functions
    func getListCountries()
    {
        NetworkManager.getListCountries(success: { (dataCountries) in
            for (id, dataCountry) in dataCountries
            {
                
                if let dataCountry = dataCountry as? NSDictionary ,let alpha3 = dataCountry["alpha3"] as? String, let curencyId = dataCountry["currencyId"]  as? String, let currencyName = dataCountry["currencyName"] as? String, let currencySymbol = dataCountry["currencySymbol"] as? String, let name = dataCountry["name"] as? String
                {
                    let countryItem = CountryModel(id: id, name: name, alpha3: alpha3, currencyid: curencyId, currencyname: currencyName, currencysymbol: currencySymbol)
                    UserSetting.sharedInstance.listCountries.append(countryItem)
                    UserSetting.sharedInstance.listCountriesName.append(name)
                    UserSetting.sharedInstance.saveDataSetting()
                }
            }
        }) { (errer) in
            
        }
    }
    
    
    func getListCurrencies()
    {
        
        let currencies = Locale.commonISOCurrencyCodes
        
        NetworkManager.getListCurrencies(success: { (dataCurrencies) in
            for (id, dataCurrency) in dataCurrencies
            {
                
                if let dataCurrency = dataCurrency as? NSDictionary, let currencyName = dataCurrency["currencyName"] as? String, let currencySymbol = dataCurrency["currencySymbol"] as? String
                {
                    
                    if(currencies.contains(id))
                    {
                        let countryCode = id.prefix(2)
                        
                        let countryLocale  = NSLocale.current
                        if let countryName = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
                        {
                            let currencyItem = CurrencyModel(id: id, currencyname: currencyName, currencysymbol: currencySymbol, countryname: countryName, countrycode: String(countryCode))
                            UserSetting.sharedInstance.listCurrenciesModel.append(currencyItem)
                            UserSetting.sharedInstance.listCurrencies!["\(id)"] = currencyItem
                            UserSetting.sharedInstance.saveDataSetting()
                        }
                    }
                    
                    
                    
                }
            }
        }) { (errer) in
            
        }
    }

}

