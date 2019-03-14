//
//  File.swift
//  Koku
//
//  Created by HoangVu on 3/13/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation

class TransactionModel {
    
    var id: Int?
    var fromCurrency: String
    var fromAmount: Float
    var toCurrency: String
    var toAmount: Float
    var exchangeRate: Float
    var fee: Float
    var totalAmount: Float
    var customerName: String
    var customerNumber: String
    var bankName: String
    var status: String
    var senderId: Int
    var sendTime: String?
    var receivedTime: String?
    var fromCurrencySymbol: String?
    var toCurrencySymbol: String?

    
    init(id: Int? = nil, fromcurrency: String, fromamount: Float, tocurrency: String, toamount: Float, exchangerate: Float, fee: Float, totalamount: Float, customername: String, customernumber: String, bankname: String, status: String, senderid : Int, sendtime: String? = nil, receivedtime: String? = nil)
    {
        self.id = id
        self.fromCurrency = fromcurrency
        self.fromAmount = fromamount
        self.toCurrency = tocurrency
        self.toAmount = toamount
        self.exchangeRate = exchangerate
        self.fee = fee
        self.totalAmount = totalamount
        self.customerName = customername
        self.customerNumber = customernumber
        self.bankName = bankname
        self.status = status
        self.sendTime = sendtime
        self.receivedTime = receivedtime
        self.senderId = senderid
        self.fromCurrencySymbol = UserSetting.sharedInstance.listCurrencies![self.fromCurrency]?.currencySymbol
        self.toCurrencySymbol = UserSetting.sharedInstance.listCurrencies![self.toCurrency]?.currencySymbol
    }
    
    

    
}
