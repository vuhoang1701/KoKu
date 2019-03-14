//
//  SendMoneySecondViewController.swift
//  Koku
//
//  Created by HoangVu on 3/14/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import iOSDropDown
import MaterialComponents

class SendMoneySecondViewController: UIViewController {
    
    @IBOutlet weak var countryTF: DropDown!
    @IBOutlet weak var nameTF: MDCTextField!
    @IBOutlet weak var bankNameTF: MDCTextField!
    @IBOutlet weak var bankNumberTF: MDCTextField!
    @IBOutlet weak var btnDismissToTabbar: UIButton!
    
    var activeTF: UITextField?
    var nameTFController: MDCTextInputControllerUnderline?
    var bankNameTFController: MDCTextInputControllerUnderline?
    var bankNumberTFController: MDCTextInputControllerUnderline?
    var transaction: TransactionModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpUI()
    {
        nameTF.delegate = self
        nameTFController = MDCTextInputControllerUnderline(textInput: nameTF)
        nameTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        nameTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        bankNameTF.delegate = self
        bankNameTFController = MDCTextInputControllerUnderline(textInput: bankNameTF)
        bankNameTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        bankNameTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        bankNumberTF.delegate = self
        bankNumberTFController = MDCTextInputControllerUnderline(textInput: bankNumberTF)
        bankNumberTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        bankNumberTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        
        countryTF.optionArray = UserSetting.sharedInstance.listCountriesName
        countryTF.selectedRowColor = UIColor.colorWithHexString(hexString: "558FA6")
        countryTF.listWillAppear {
            let lineView = self.view.viewWithTag(100)
            lineView?.backgroundColor = UIColor.colorWithHexString(hexString: "558FA6")
            self.activeTF = self.countryTF
            
            
        }
        countryTF.listDidDisappear(completion: {
            let lineView = self.view.viewWithTag(100)
            lineView?.backgroundColor = UIColor.lightGray
            
        })
        
    }
    

    
    func isValidInputValue() -> Bool
    {
        if let firtName = nameTF.text , firtName == ""
        {
            nameTFController?.setErrorText("Please input receipent name", errorAccessibilityValue: nil)
            return false
        }
        if let bankName = bankNameTF.text , bankName == ""
        {
            bankNameTFController?.setErrorText("Please input bank name", errorAccessibilityValue: nil)
            return false
        }
        if let bankNumber = bankNumberTF.text
        {
            if(bankNumber == "")
            {
                bankNumberTFController?.setErrorText("Please input bank number", errorAccessibilityValue: nil)
                return false
            }
           
        }
        if let country = countryTF.text , !UserSetting.sharedInstance.listCountriesName.contains(country)
        {
            let alert = UIAlertController(title: "Error", message: "Country is not correct. Please try again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        if(isValidInputValue())
        {
            guard let currentUser = UserSetting.sharedInstance.currentUser else
            {
                return
            }
            currentUser.country = countryTF.text

            transaction?.customerName = (nameTF.text)!
            transaction?.customerNumber = (bankNumberTF.text)!
            transaction?.bankName = (bankNameTF.text)!
            transaction?.sendTime = Date.ISOStringFromDate(date: Date())

            let loadingView = UIViewController.showLoading(onView: view)

            NetworkManager.postTransaction(transaction: transaction!, success: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIViewController.hideLoading(view: loadingView)
                    //Post notification to reload activity list
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadActivityList"), object: nil, userInfo: nil)
                    
                    //Unwind to tabbar view
                    self.btnDismissToTabbar .sendActions(for: .touchUpInside)
                }
            }) { (error) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIViewController.hideLoading(view: loadingView)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

                    self.present(alert, animated: true)
                }
            }


        }
       
        
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.cgRectValue.height
        if let activeField = self.activeTF {
            if (!aRect.contains(activeField.frame.origin)){
                
                if self.view.frame.origin.y == 0
                {
                    self.view.frame.origin.y -= keyboardFrame.height
                }
                
            }
            if (self.activeTF as? DropDown) != nil
            {
                if self.view.frame.origin.y == 0
                {
                    self.view.frame.origin.y -= keyboardFrame.height
                }
            }
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0
        {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    @IBAction func TapOutView(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    @IBAction func unwindToTabbar(_ sender: Any) {
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}


extension SendMoneySecondViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTF = textField
        if (textField as? MDCTextField == nameTF)
        {
            nameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == bankNameTF)
        {
            bankNameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == bankNumberTF)
        {
            bankNumberTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTF = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
