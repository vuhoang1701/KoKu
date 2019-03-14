//
//  ActivityTableViewCell.swift
//  Koku
//
//  Created by HoangVu on 3/13/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

class ActivityTableViewCellContent {
    var dataModel: TransactionModel?
    var expanded: Bool
    init(datamodel: TransactionModel? = nil) {
        self.dataModel = datamodel
        self.expanded = true
    }
}

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderTimeLbel: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var customerNameLbel: UILabel!
    @IBOutlet weak var statusLbel: UILabel!
    @IBOutlet weak var fromToCurrencyLbel: UILabel!
    @IBOutlet weak var toAmountWithCurrency: UILabel!
    @IBOutlet weak var bankNameLbel: UILabel!
    @IBOutlet weak var bankNumberLbel: UILabel!
    @IBOutlet weak var exchangeRateLbel: UILabel!
    @IBOutlet weak var receivedAmountLbel: UILabel!
    @IBOutlet weak var feeLbel: UILabel!
    @IBOutlet weak var paidAmountWithCurrency: UILabel!
    @IBOutlet weak var heightConstain45: NSLayoutConstraint!
    @IBOutlet weak var heightConstaint30: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(content: ActivityTableViewCellContent) {
        
        heightConstain45.constant = content.expanded ? 45 : 0
        heightConstaint30.constant = content.expanded ? 30 : 0
        self.viewWithTag(99)?.backgroundColor = content.expanded ?  UIColor.colorWithHexString(hexString: "558FA6") : UIColor.clear 
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy HH:mm a"
        if let date = Date.dateFromISOString(string: (content.dataModel?.sendTime)!)
        {
            senderTimeLbel.text = formatter.string(from: date)
        }
        
        
        if let fullname = content.dataModel?.customerName
        {
            customerNameLbel.text = fullname
            var stringInputArr = fullname.components(separatedBy:" ")
            for string in stringInputArr
            {
                if (string == "")
                {
                    stringInputArr.remove(at: stringInputArr.firstIndex(of: string)!)
                }
            }
            var stringNeed = ""
            if(stringInputArr.count > 0)
            {
                stringNeed = stringNeed + String(stringInputArr[0].first!).uppercased()
                stringNeed = stringNeed + String(stringInputArr[stringInputArr.count-1].first!).uppercased()
            }
            
            avatarBtn.setTitle(stringNeed, for: .normal)
            
        }
        
        if let status = content.dataModel?.status
        {
            statusLbel.text = "Status: " + status
            
            switch status.lowercased() {
            case "completed":
                statusView.backgroundColor = UIColor.green
                break
            case "pending":
                statusView.backgroundColor = UIColor.yellow
                break
            case "cancel", "error":
                statusView.backgroundColor = UIColor.red
                break
            default:
                break
            }
            
        }
        else{
             statusLbel.text = "Status: --- "
            statusView.backgroundColor = UIColor.lightGray
        }
        
        if let fromCurrency = content.dataModel?.fromCurrency, let toCurrency =  content.dataModel?.toCurrency
        {
            fromToCurrencyLbel.text = "\(fromCurrency) -> \(toCurrency)"
            
        }
        
        
        if let sendAmount = content.dataModel?.fromAmount
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:sendAmount))
            toAmountWithCurrency.text = "- \(String(describing: (content.dataModel?.fromCurrencySymbol)!))\(String(describing: formattedNumber!)) \(String(describing: (content.dataModel?.fromCurrency)!))"
        }
        if let bankName = content.dataModel?.bankName
        {
            bankNameLbel.text = bankName
            
        }
        else{
            bankNameLbel.text = "Bank name: --- "
        }
        
        if let banknumber = content.dataModel?.customerNumber
        {
            bankNumberLbel.text = "No.: " + banknumber
            
        }
        else{
            bankNumberLbel.text = "No.: --- "
        }
       
        
        if let feeAmount = content.dataModel?.fee
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:feeAmount))
            feeLbel.text = "Fee: \(String(describing: (content.dataModel?.fromCurrencySymbol)!))\(String(describing: formattedNumber!)) \(String(describing: (content.dataModel?.fromCurrency)!))"
            
        }
        else{
            feeLbel.text = "Fee: --- "
        }
        
        if let paidAmount = content.dataModel?.totalAmount
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:paidAmount))
            paidAmountWithCurrency.text = "Paid: \(String(describing: (content.dataModel?.fromCurrencySymbol)!))\(String(describing: formattedNumber!)) \(String(describing: (content.dataModel?.fromCurrency)!))"
            
        }
        else{
            toAmountWithCurrency.text = "Paid: --- "
        }
        
        if let rate = content.dataModel?.exchangeRate
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:rate))
            exchangeRateLbel.text = "Rate : \(String(describing: formattedNumber!)) "
            
        }
        else{
            exchangeRateLbel.text = "Rate: --- "
        }
        
        if let receivedAmount = content.dataModel?.toAmount
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:receivedAmount))
            receivedAmountLbel.text = "Rcvd :\(String(describing: (content.dataModel?.toCurrencySymbol)!))\(String(describing: formattedNumber!)) \(String(describing: (content.dataModel?.toCurrency)!))"
            
        }
        else{
            receivedAmountLbel.text = "Rcvd: --- "
        }
        
        
        
        
    }
    
}

