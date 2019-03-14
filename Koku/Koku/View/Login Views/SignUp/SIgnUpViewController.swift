//
//  SIgnUpViewController.swift
//  Koku
//
//  Created by HoangVu on 3/8/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import MaterialComponents

protocol SIgnUpViewDelegate {
    func loadViewContentWithStage(stage: Stage)
    func registerNewAccount(userModel: UserModel)
}

enum UserRole: String
{
    case Business
    case Personal
}

class SIgnUpViewController: UIViewController {

    var delegate: SIgnUpViewDelegate?
    var activeTF: UITextField?
    @IBOutlet weak var referTF: MDCTextField!
    @IBOutlet weak var revealPasswordBtn: UIButton!
    @IBOutlet weak var userNameTF: MDCTextField!
    @IBOutlet weak var switchIsBusiness: UISwitch!
    @IBOutlet weak var passwordTF: MDCTextField!
    var userNameTFController: MDCTextInputControllerUnderline?
    var passwordTFController: MDCTextInputControllerUnderline?
    var referralTFController: MDCTextInputControllerUnderline?
    var updateTFWithError: ((NSError) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setUpUI()
    {
        userNameTF.delegate = self
        userNameTFController = MDCTextInputControllerUnderline(textInput: userNameTF)
        userNameTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        userNameTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        passwordTF.delegate = self
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.isSecureTextEntry = true
        passwordTF.backgroundColor = .white
        passwordTF.clearButtonMode = .never
        passwordTFController = MDCTextInputControllerUnderline(textInput: passwordTF)
        passwordTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        passwordTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        
        referTF.delegate = self
        referralTFController = MDCTextInputControllerUnderline(textInput: referTF)
        referralTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        referralTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        
    }
    
    func isValidInputValue() -> (isValid:Bool, email: String?, password:String?)
    {
        if let email = userNameTF.text , email.isValidEmail()
        {
            
            if let password = passwordTF.text, password != ""
            {
                
                return (isValid:true, email: email, password:password)
            }
            else
            {
                passwordTFController?.setErrorText("Please input password", errorAccessibilityValue: nil)
                return (isValid:false, email: nil, password:nil)
            }
        }
        else
        {
            userNameTFController?.setErrorText("Your email is not correct", errorAccessibilityValue: nil)
            return (isValid:false, email: nil, password:nil)
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
    
    
    @IBAction func revealPasswordBtnTapped(_ sender: Any) {
        let senderButton = sender as? UIButton
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
        if let textRange = passwordTF.textRange(from: passwordTF.beginningOfDocument, to: passwordTF.endOfDocument) {
            if( passwordTF.isSecureTextEntry)
            {
                senderButton?.setImage(UIImage(named: "Eye"), for: .normal)
            }
            else
            {
                passwordTF.replace(textRange, withText: passwordTF.text!)
                senderButton?.setImage(UIImage(named: "Eye-Out-Time"), for: .normal)
            }
            
        }
        
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        delegate?.loadViewContentWithStage(stage: .LoginView)
    }
    @IBAction func signUpBtnTapped(_ sender: Any) {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        referTF.resignFirstResponder()
        if(!isValidInputValue().isValid)
        {
            return
        }

        NetworkManager.CheckAccountExist(email: (self.userNameTF?.text)!, success: { (isExist) in
            if(isExist)
            {
                self.userNameTFController?.setErrorText("This email is exist", errorAccessibilityValue: nil)
            }

        })
        { (error) in
        }

        if( self.userNameTFController?.errorText == nil )
        {
            NetworkManager.CheckAccountExist(email: (self.userNameTF?.text)!, success: { (isExist) in
                if(isExist)
                {
                    self.userNameTFController?.setErrorText("This email is exist", errorAccessibilityValue: nil)
                }
                else
                {
                    DispatchQueue.main.async {
                        let stringRole: UserRole = (self.switchIsBusiness?.isOn)! ? UserRole.Business : UserRole.Personal
                        let userModel = UserModel(email: (self.userNameTF?.text)!.lowercased(), role: stringRole.rawValue, password: self.passwordTF?.text)
                        self.delegate?.registerNewAccount(userModel: userModel)
                    }

                }
            }) { (error) in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
    
}


extension SIgnUpViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField as? MDCTextField == userNameTF)
        {
            if let email = textField.text, email != ""
            {
                NetworkManager.CheckAccountExist(email: email, success: { (isExist) in
                    if(isExist)
                    {
                        self.userNameTFController?.setErrorText("This is email is exist", errorAccessibilityValue: nil)
                    }
                }) { (error) in
                    print(error.domain)
                }
            }
            userNameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField as? MDCTextField == userNameTF)
        {
            userNameTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == passwordTF)
        {
            passwordTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
