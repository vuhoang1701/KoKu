//
//  SendMoneyFirstViewController.swift
//  Koku
//
//  Created by HoangVu on 3/13/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import BubbleTransition

class SendMoneyFirstViewController: UIViewController, UIViewControllerTransitioningDelegate {

    let transition = BubbleTransition()
    @IBOutlet weak var selectFromView: UIView!
    @IBOutlet weak var selectToView: UIView!
    @IBOutlet weak var selectFromCurrencyBtn: UIButton!
    @IBOutlet weak var selectToCurrencyBtn: UIButton!
    

    @IBOutlet weak var feeLbel: UILabel!
    @IBOutlet weak var amountConvertedLbel: UILabel!
    @IBOutlet weak var exchangeRateLbel: UILabel!
    
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var fromFlagImage: UIImageView!
    @IBOutlet weak var fromCurrencyLbel: UILabel!
    
     @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var toFlagImage: UIImageView!
    @IBOutlet weak var toCurrencyLbel: UILabel!
    
    var totalAmount: Float!
    var convertedAmount: Float!
    var toAmount: Float! = 0
    var fees: Float!
    var rateCurrencyToUsd: Float!
    var exchangeRate: Float!
    
    var tappedButtonString: String?
    var fromCurrencyModel = UserSetting.sharedInstance.listCurrenciesModel.filter{
        currency in
        return (currency.id.lowercased() == "sgd")
    }.first
    var toCurrencyModel = UserSetting.sharedInstance.listCurrenciesModel.filter{
        currency in
        return (currency.id.lowercased() == "usd")
    }.first
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        parseDataToView()
        getRate()
    
    }
    
    
    // PRAGMA MARK: - Methods
    func setUpUI()
    {
        selectFromView.layer.borderColor = UIColor.lightGray.cgColor
        selectFromView.layer.borderWidth = 1
        
        selectToView.layer.borderColor = UIColor.lightGray.cgColor
        selectToView.layer.borderWidth = 1
        fromTF.text = "1000"
        totalAmount = 1000
        fromTF.text?.toDecimalFormat()
        toTF.delegate = self
        fromTF.delegate = self
      
    }
    
    func parseDataToView()
    {
        if let imgPath = Bundle.main.path(forResource: fromCurrencyModel?.countryCode, ofType: "png"){
            fromFlagImage?.image = UIImage(named: imgPath)
        }
        fromCurrencyLbel.text = fromCurrencyModel?.id
        
        
        if let imgPath = Bundle.main.path(forResource: toCurrencyModel?.countryCode, ofType: "png"){
            toFlagImage?.image = UIImage(named: imgPath)
        }
        toCurrencyLbel.text = toCurrencyModel?.id
        
        
       
    }
    
    func processCalculateToCurrencyByFromCurrency ()
    {
        var fee: Float = 0
        var amountConverted: Float = 0
        
        //Fee is 3.4%*sendAmount + 1USD
        if let sendAmount = fromTF?.text
        {
            fee = rateCurrencyToUsd! +  0.034 * sendAmount.floatValue
            amountConverted = sendAmount.floatValue
            totalAmount = sendAmount.floatValue
        }
        else
        {
             fee = rateCurrencyToUsd! +  0.034
             totalAmount = 0
        }
        feeLbel.text = "\(String.toDecimalFormat(float: fee)) \(fromCurrencyModel!.id) Koku fees"
        
        
        //Amount Converted = sendAmount - Fees
        amountConverted -= fee
        amountConvertedLbel.text = (amountConverted > 0) ?  "\(String.toDecimalFormat(float: amountConverted)) \(fromCurrencyModel!.id) Amount converted" : "0 Amount converted"
        
        //Get Exchange fee
        exchangeRateLbel.text = "\(String.toDecimalFormat(float: exchangeRate)) Exchange rate"
    
        //Calculate receipient gets = amountConverted* exchangeRate
        toTF.text = (amountConverted*exchangeRate > 0) ? "\(amountConverted*exchangeRate)": "0"
        toTF.text?.toDecimalFormat()
        
        fees = fee
        convertedAmount = (amountConverted > 0) ? amountConverted: 0
        toAmount = (amountConverted*exchangeRate > 0) ? (amountConverted*exchangeRate) : 0
        
      
    }
    
    
    func processCalculateFromCurrencyByToCurrency ()
    {
        var amountConverted: Float = 0
        //Calculate amountConvert base on receivedAmount and exchangeRate
        if let receivedAmount = toTF?.text
        {
            amountConverted = receivedAmount.floatValue/exchangeRate
            amountConvertedLbel.text = (amountConverted > 0) ?  "\(String.toDecimalFormat(float: amountConverted)) \(fromCurrencyModel!.id) Amount converted" : "0 Amount converted"
        }
        
        //Get sendAmount and free
        exchangeRateLbel.text = "\(String.toDecimalFormat(float: exchangeRate)) Exchange rate"
        var fee: Float = 0
        var sendAmount: Float = 0
        sendAmount = (amountConverted + rateCurrencyToUsd)/(1-0.34)
        fee = rateCurrencyToUsd! +  0.034 * sendAmount
        
        feeLbel.text = "\(String.toDecimalFormat(float: fee)) \(fromCurrencyModel!.id) Koku fees"
        fromTF.text = "\(sendAmount)"
        fromTF.text?.toDecimalFormat()
        
        fees = fee
        convertedAmount = (amountConverted > 0) ? amountConverted: 0
        toAmount = (amountConverted*exchangeRate > 0) ? (amountConverted*exchangeRate) : 0
        totalAmount = sendAmount
    }
    
    
    func getRate()
    {
        //Call couple rates of fromCurrency-USD and fromCurrency-toCurrency
        if let fromCurrencyModel = fromCurrencyModel, let toCurrencyModel = toCurrencyModel
        {
            let rateWithUsd = "USD_\(fromCurrencyModel.id)"
            let rateFromCtoC = "\(fromCurrencyModel.id)_\(toCurrencyModel.id)"
            NetworkManager.getRateExchange(rateWithUSD: rateWithUsd, twoCurrency: rateFromCtoC, success: { (returnData) in
              
                    self.rateCurrencyToUsd = returnData[rateWithUsd]
                    self.exchangeRate = returnData[rateFromCtoC]
                    DispatchQueue.main.async {
                        self.processCalculateToCurrencyByFromCurrency()
                }
            }) { (error) in
                
            }
        }
    }

    // PRAGMA MARK: - Actions Of Button
    @IBAction func TapOutView(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectFromCurrencyBtnTapped(_ sender: Any) {
        
        tappedButtonString = "fromButton"
        performSegue(withIdentifier: "showSelectCurrencyView", sender: self)
        
    }
    
    @IBAction func selectToCurrencyBtnTapped(_ sender: Any) {
        tappedButtonString = "toButton"
        performSegue(withIdentifier: "showSelectCurrencyView", sender: self)
    }
    
    @IBAction func ContinueBtnTapped(_ sender: Any) {

        if(totalAmount == 0 || toAmount == 0)
        {
            return
        }
        
        performSegue(withIdentifier: "showReceipentView", sender: self)
        
    }
    
    
    
    // PRAGMA MARK: - Prepare Segue
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    
        if(segue.identifier == "showSelectCurrencyView")
        {
            if let destinationNavigationController = segue.destination as? UINavigationController,
            let vc = destinationNavigationController.topViewController as? SelectCurrencyViewController
            {
                
                //Handle data and closure return after selecting currency
                if(tappedButtonString == "fromButton")
                {
                    vc.fromCurrencyId = fromCurrencyModel?.id
                    vc.toCurrencyId = toCurrencyModel?.id
                    vc.isSelectFromCurrency = true
                    vc.returnSelectedCurrencyModel = { (currencyModel) in
                        self.fromCurrencyModel = currencyModel
                        DispatchQueue.main.async {
                            self.parseDataToView()
                            self.getRate()
                        }
                        
                    }

                }
                else if(tappedButtonString == "toButton")
                {
                    vc.fromCurrencyId = fromCurrencyModel?.id
                    vc.toCurrencyId = toCurrencyModel?.id
                    vc.isSelectFromCurrency = false
                    vc.returnSelectedCurrencyModel = { (currencyModel) in
                        self.toCurrencyModel = currencyModel
                        DispatchQueue.main.async {
                            self.parseDataToView()
                            self.getRate()
                        }
                    }
                }
            }
        }
        else if(segue.identifier == "showReceipentView")
        {
             if let destinationController = segue.destination as? SendMoneySecondViewController
             {
                let transactionModel = TransactionModel(fromcurrency: fromCurrencyModel!.id, fromamount: convertedAmount, tocurrency: toCurrencyModel!.id, toamount: toAmount, exchangerate: exchangeRate, fee: fees, totalamount: totalAmount, customername: "", customernumber: "", bankname: "", status: "Pending", senderid: UserSetting.sharedInstance.currentUser!.id!)
                destinationController.transaction = transactionModel
            }
        }
    }
    
    
   
    
    
    
    // PRAGMA MARK: - UIViewControllerTransitioningDelegate of bubble transition
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let tappedButtonString = self.tappedButtonString
        {
            transition.transitionMode = .present
            transition.duration = 0.3
            if(tappedButtonString == "fromButton")
            {
                transition.startingPoint = self.selectFromCurrencyBtn.convert(self.selectFromCurrencyBtn.center, to: self.view)
            }
            else if(tappedButtonString == "toButton")
            {
                 transition.startingPoint = self.selectToCurrencyBtn.convert(self.selectToCurrencyBtn.center, to: self.view)
            }
            transition.bubbleColor = UIColor.colorWithHexString(hexString: "558FA6")
                return transition
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let tappedButtonString = self.tappedButtonString
        {
            transition.transitionMode = .dismiss
            transition.duration = 0.3
            if(tappedButtonString == "fromButton")
            {
                transition.startingPoint = self.selectFromCurrencyBtn.convert(self.selectFromCurrencyBtn.center, to: self.view)
            }
            else if(tappedButtonString == "toButton")
            {
                transition.startingPoint = self.selectToCurrencyBtn.convert(self.selectToCurrencyBtn.center, to: self.view)
            }
            transition.bubbleColor = UIColor.colorWithHexString(hexString: "558FA6")
            self.tappedButtonString = nil
            return transition
            
        }
        return nil
    }
}


// PRAGMA MARK: - UITextFieldDelegate
extension SendMoneyFirstViewController: UITextFieldDelegate
{
    //User can edit both text field so this code handle this data return
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((string == "0" || string == "") && (textField.text! as NSString).range(of: ".").location < range.location) {
            if(textField == fromTF)
            {
                processCalculateToCurrencyByFromCurrency()
            }
            else if(textField == toTF)
            {
                processCalculateFromCurrencyByToCurrency()
            }
            return true
        }
        
        // First check whether the replacement string's numeric...
        let cs = NSCharacterSet(charactersIn: "0123456789.").inverted
        let filtered = string.components(separatedBy: cs)
        let component = filtered.joined(separator: "")
        let isNumeric = string == component
        
        // Then if the replacement string's numeric, or if it's
        // a backspace, or if it's a decimal point and the text
        // field doesn't already contain a decimal point,
        // reformat the new complete number using
        if isNumeric {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 8
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberWithOutCommas = newString.replacingOccurrences(of: ",", with: "")
            let number = formatter.number(from: numberWithOutCommas)
            if number != nil {
                var formattedString = formatter.string(from: number!)
                // If the last entry was a decimal or a zero after a decimal,
                // re-add it here because the formatter will naturally remove
                // it.
                if string == "." && range.location == textField.text?.count {
                    formattedString = formattedString?.appending(".")
                }
                textField.text = formattedString
            } else {
                textField.text = nil
            }
        }
        if(textField == fromTF)
        {
            processCalculateToCurrencyByFromCurrency()
        }
        else if(textField == toTF)
        {
            processCalculateFromCurrencyByToCurrency()
        }
        return false
        
    }
    

   
    
}
