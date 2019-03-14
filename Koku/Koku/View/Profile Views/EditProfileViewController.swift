//
//  EditProfileViewController.swift
//  Koku
//
//  Created by HoangVu on 3/10/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import MaterialComponents
import iOSDropDown

class EditProfileViewController: UIViewController {
    @IBOutlet weak var countryTF: DropDown!
    @IBOutlet weak var phoneNumberTF: MDCTextField!
    @IBOutlet weak var firstNameTF: MDCTextField!
    @IBOutlet weak var lastNameTF: MDCTextField!
    
    var activeTF: UITextField?
    var firstNameTFController: MDCTextInputControllerUnderline?
    var lastNameTFController: MDCTextInputControllerUnderline?
    var countryTFController: MDCTextInputControllerUnderline?
    var phoneNumberTFController: MDCTextInputControllerUnderline?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpData()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpUI()
    {
        firstNameTF.delegate = self
        firstNameTFController = MDCTextInputControllerUnderline(textInput: firstNameTF)
        firstNameTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        firstNameTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        lastNameTF.delegate = self
        lastNameTFController = MDCTextInputControllerUnderline(textInput: lastNameTF)
        lastNameTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        lastNameTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        
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
        
        //Its Id Values and its optionalVuh
        phoneNumberTF.delegate = self
        phoneNumberTF.keyboardType = .phonePad
        phoneNumberTFController = MDCTextInputControllerUnderline(textInput: phoneNumberTF)
        phoneNumberTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        phoneNumberTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
    }
    
    func setUpData()
    {
        firstNameTF.text = UserSetting.sharedInstance.currentUser?.firstName
        lastNameTF.text = UserSetting.sharedInstance.currentUser?.lastName
        phoneNumberTF.text = UserSetting.sharedInstance.currentUser?.phoneNumber
        countryTF.text = UserSetting.sharedInstance.currentUser?.country
    }
    
    func isValidInputValue() -> Bool
    {
        if let firtName = firstNameTF.text , firtName == ""
        {
            firstNameTFController?.setErrorText("Please input first name", errorAccessibilityValue: nil)
            return false
        }
        if let lastName = lastNameTF.text , lastName == ""
        {
            lastNameTFController?.setErrorText("Please input last name", errorAccessibilityValue: nil)
            return false
        }
        if let phoneNumber = phoneNumberTF.text
        {
            if(phoneNumber == "")
            {
                phoneNumberTFController?.setErrorText("Please input your phone number", errorAccessibilityValue: nil)
                return false
            }
            else if( !phoneNumber.isValidatePhoneNumber())
            {
                phoneNumberTFController?.setErrorText("Phone number format is not correct", errorAccessibilityValue: nil)
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
            currentUser.firstName = firstNameTF.text
            currentUser.lastName = lastNameTF.text
            currentUser.phoneNumber = phoneNumberTF.text
            let loadingView = UIViewController.showLoading(onView: view)
            NetworkManager.updateAccountDetail(userModel: currentUser, success: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIViewController.hideLoading(view: loadingView)
                    self.dismiss(animated: true, completion: nil)
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
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}


extension EditProfileViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTF = textField
        if (textField as? MDCTextField == firstNameTF)
        {
            firstNameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == lastNameTF)
        {
            lastNameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == phoneNumberTF)
        {
            phoneNumberTFController?.setErrorText(nil, errorAccessibilityValue: nil)
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
