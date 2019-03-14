//
//  UserModel.swift
//  Koku
//
//  Created by HoangVu on 3/10/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation

class UserModel: NSObject, NSCoding, NSCopying {
    
    var firstName: String?
    var lastName: String?
    var email: String
    var password: String?
    var id: Int?
    var role: String
    var phoneNumber: String?
    var country: String?
    
    override init()
    {
        email = ""
        role = ""
    }
    
    init(email: String, role: String, password: String? = nil) {
        self.email = email
        self.role = role
        self.password = password
    }
    init(id: Int? = nil, email: String, role: String , firstname: String? = nil , lastname: String? = nil , phonenumber: String? = nil,  country: String? = nil, password: String? = nil) {
        self.id = id
        self.email = email
        self.role = role
        self.firstName = firstname
        self.lastName = lastname
        self.phoneNumber = phonenumber
        self.country = country
        self.password = password
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let role = aDecoder.decodeObject(forKey: "role") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        let country = aDecoder.decodeObject(forKey: "country") as? String
        let password = aDecoder.decodeObject(forKey: "password") as? String
        self.init(id: id, email: email, role: role, firstname: firstName, lastname: lastName, phonenumber: phoneNumber, country: country, password: password)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(role, forKey: "role")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(password, forKey: "password")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = UserModel(id: id, email: email, role: role, firstname: firstName, lastname: lastName, phonenumber: phoneNumber, country: country, password: password )
        return copy
    }
    
}
