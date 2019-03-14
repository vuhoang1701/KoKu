//
//  NetworkManager.swift
//  Koku
//
//  Created by HoangVu on 3/7/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import Alamofire
class NetworkManager {
    
    static let baseURL = "http://localhost:3000/"
    static let baseURLOfFreeCurrency = "https://free.currencyconverterapi.com/api/v6/"
    static let keyOfFreeCurrency = "3fd44f85139d44570684"
    private static let sessionManager = Alamofire.SessionManager()
    private static let queue = DispatchQueue(label: "HoangVu.Koku" + UUID().uuidString)
    
    
    static func getRateExchange(rateWithUSD: String, twoCurrency: String , success: @escaping (_ rateListReturn: [String : Float] ) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let stringURL: String = baseURLOfFreeCurrency + "convert?"
        let paramFromTo = "\(rateWithUSD),\(twoCurrency)"
        let parameters = ["apiKey":keyOfFreeCurrency, "q":paramFromTo, "compact":"ultra"]
        self.request(stringURL, method: .get, parameters: parameters, success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?,
            let firstItem = jsonDictionary.value(forKey: rateWithUSD) as? Double, let secondItem = jsonDictionary.value(forKey: twoCurrency) as? Double
            {
                
                let dic:[String : Float] = [rateWithUSD: Float(firstItem), twoCurrency: Float(secondItem)]
                success(dic)
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func getListCountries(success: @escaping (_ arrayTrendItems: [String:Any]) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let stringURL: String = baseURLOfFreeCurrency + "countries"
        let parameters = ["apiKey":keyOfFreeCurrency]
        self.request(stringURL, method: .get, parameters: parameters, success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?,
                let arrayCountries = jsonDictionary["results"] as? [String : Any]
            {
                success(arrayCountries)
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    static func getListCurrencies(success: @escaping (_ arrayTrendItems: [String:Any]) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let stringURL: String = baseURLOfFreeCurrency + "currencies"
        let parameters = ["apiKey":keyOfFreeCurrency]
        self.request(stringURL, method: .get, parameters: parameters, success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?,
                let arrayCurrencies = jsonDictionary["results"] as? [String : Any]
            {
                success(arrayCurrencies)
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    static func login(email: String, password: String ,success: @escaping () -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let loginURL = baseURL + "users?email=\(email)"
        self.request(loginURL, method: .get, parameters: nil, success: { (jsonData) in
            if let jsonArray = jsonData as? [Any] as NSArray?, jsonArray.count > 0,
                let jsonFirstItem = jsonArray[0] as? [NSObject : Any] as NSDictionary?
            {
                if let passwrd = jsonFirstItem["password"] as? String
                {
                    if(passwrd == password)
                    {
                        let id = jsonFirstItem["id"] as? Int
                        let email = jsonFirstItem["email"] as? String
                        let role = jsonFirstItem["role"] as? String
                        let firstname = jsonFirstItem["firstName"] as? String
                        let lastname = jsonFirstItem["lastName"] as? String
                        let phonenumber = jsonFirstItem["phoneNumber"] as? String
                        let country = jsonFirstItem["country"] as? String
                        let password = jsonFirstItem["password"] as? String
                        
                        let currentUser = UserModel(id: id, email: email!, role: role!, firstname: firstname, lastname: lastname, phonenumber: phonenumber, country: country, password: password)
                        UserSetting.sharedInstance.currentUser = currentUser
                        UserSetting.sharedInstance.saveCurrentUserToUserDefault()
                        success()
                    }
                    else
                    {
                        failure(NSError(domain: "Password is not correct!", code: 401, userInfo: nil))
                    }
                }

            }
            else
            {
                failure(NSError(domain: "User is not exist!", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    static func signUpNewAccount(userModel: UserModel ,success: @escaping () -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
        let signUpURL = baseURL + "users/"
        let parameters = ["email":userModel.email, "role": userModel.role, "password": userModel.password!]
        self.request(signUpURL, method: .post, parameters: parameters, success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?
            {
                let currentUser = UserModel(email: (jsonDictionary["email"] as? String)!, role: (jsonDictionary["role"] as? String)!, password: jsonDictionary["password"] as? String)
                currentUser.id =  (jsonDictionary["id"] as? Int)
                UserSetting.sharedInstance.currentUser = currentUser
                UserSetting.sharedInstance.saveCurrentUserToUserDefault()
                success()
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func updateAccountDetail(userModel: UserModel ,success: @escaping () -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
     
        let signUpURL = baseURL + "users/\(userModel.id!)"
        let parameters = ["email": userModel.email, "role": userModel.role, "password": userModel.password!, "firstName": userModel.firstName!, "lastName": userModel.lastName!, "phoneNumber": userModel.phoneNumber!, "country": userModel.country!]
        self.request(signUpURL, method: .put, parameters: parameters , success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?
            {
                 let currentUser = UserSetting.sharedInstance.currentUser
                currentUser?.firstName = (jsonDictionary["firstName"] as? String)
                currentUser?.lastName = (jsonDictionary["lastName"] as? String)
                currentUser?.phoneNumber = (jsonDictionary["phoneNumber"] as? String)
                currentUser?.country = (jsonDictionary["country"] as? String)
                currentUser?.password = (jsonDictionary["password"] as? String)
                UserSetting.sharedInstance.currentUser = currentUser
                UserSetting.sharedInstance.saveCurrentUserToUserDefault()
                success()
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func postTransaction(transaction: TransactionModel ,success: @escaping () -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
        let transactionURL = baseURL + "transactions/"
        let parameters = ["fromCurrency":transaction.fromCurrency,
                          "fromAmount": transaction.fromAmount,
                          "toCurrency": transaction.toCurrency,
                          "toAmount": transaction.toAmount,
                          "exchangeRate": transaction.exchangeRate ,
                          "fee": transaction.fee,
                          "totalAmount": transaction.totalAmount,
                          "customerName": transaction.customerName,
                          "customerNumber": transaction.customerNumber,
                          "status": transaction.status,
                          "senderId": transaction.senderId,
                          "bankName": transaction.bankName,
                          "sendTime": transaction.sendTime!] as [String : Any]
        self.request(transactionURL, method: .post, parameters: parameters, success: { (jsonData) in
            if let jsonDictionary = jsonData as? [NSObject : Any] as NSDictionary?
            {
                
//                let id = jsonDictionary["id"] as? Int
//                let fromAmount = jsonDictionary["fromAmount"] as? Float
//                let fromCurrency = jsonDictionary["fromCurrency"] as? String
//                let toAmount = jsonDictionary["toAmount"] as? Float
//                let toCurrency = jsonDictionary["toCurrency"] as? String
//                let exchangeRate = jsonDictionary["exchangeRate"] as? Float
//                let fee = jsonDictionary["fee"] as? Float
//                let totalAmount = jsonDictionary["totalAmount"] as? Float
//                let customerName = jsonDictionary["customerName"] as? String
//                let customerNumber = jsonDictionary["customerNumber"] as? String
//                let bankName = jsonDictionary["bankName"] as? String
//                let status = jsonDictionary["status"] as? String
//                let senderId = jsonDictionary["senderId"] as? Int
//                let sendTime = jsonDictionary["sendTime"] as? String
//                let receivedTime = jsonDictionary["receivedTime"] as? String
//
//                let transactionModel = TransactionModel(id: id!, fromcurrency: fromCurrency!, fromamount: fromAmount!, tocurrency: toCurrency!, toamount: toAmount!, exchangerate: exchangeRate!, fee: fee!, totalamount: totalAmount!, customername: customerName!, customernumber: customerNumber!, bankname: bankName!, status: status!, senderid: senderId!)
//                transactionModel.sendTime = sendTime
//                transactionModel.receivedTime = receivedTime
//
                success()
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func getListTransactions(success: @escaping (_ arrayTransactions: [[String:Any]]) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let stringURL = baseURL + "transactions"
        let param = ["senderId": UserSetting.sharedInstance.currentUser!.id!]
        self.request(stringURL, method: .get, parameters: param, success: { (jsonData) in
            if let jsonArray = jsonData as? [[String:Any]] as NSArray?
            {
                success(jsonArray as! [[String : Any]])
            }
            else
            {
                failure(NSError(domain: "Data is not valid", code: 404, userInfo: nil))
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    static func CheckAccountExist(email: String ,success: @escaping (_ isExist: Bool) -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
        let loginURL = baseURL + "users?email=\(email)"
        self.request(loginURL, method: .get, parameters: nil, success: { (jsonData) in
            if let jsonArray = jsonData as? [Any] as NSArray?, jsonArray.count > 0
            {
                
                success(true)
                
           
                
            }
            else
            {
                success(false)
                
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    
    
    private static func request(_ stringURL: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, success: @escaping (_ returnData: Any) -> Void, failure: @escaping (_ error: NSError) -> Void)
    {
        var cumulateHeader: HTTPHeaders = [:]
        cumulateHeader["Content-Type"] = "application/x-www-form-urlencoded"
        
        let completion: (DataResponse<Any>) -> Void = { (response) -> Void in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error as NSError)
            }
        }
        
        self.sessionManager.request(stringURL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: cumulateHeader).validate().responseJSON(queue: queue, completionHandler: completion)
    }
    
}

