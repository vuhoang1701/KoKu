//
//  StringExtension.swift
//  Koku
//
//  Created by HoangVu on 3/9/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidatePhoneNumber() -> Bool {
        var stringPhoneNumber = self
        if (stringPhoneNumber.hasPrefix("+")) {
            stringPhoneNumber.remove(at: stringPhoneNumber.startIndex)
        }
        let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: stringPhoneNumber)
        return valid
    }
    
    
    //Convert current string to decimal contain thousand seperate comma
    mutating func toDecimalFormat(){
        let number = Float(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = number, let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
        {
            self = formattedNumber
        }
    }
    
    //Convert float value to String contain thousand seperate comma
    static func toDecimalFormat(float : Float) -> String{
        var stringNumber = "\(float)"
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 5
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:float))
        {
            stringNumber = formattedNumber
        }
        return stringNumber
    }
    
    
    //Convert current string to float value
    static let numberFormatter = NumberFormatter()
    var floatValue: Float {
        String.numberFormatter.numberStyle = .decimal
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.floatValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}
