//
//  LoginViewController.swift
//  Koku
//
//  Created by HoangVu on 3/8/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import MaterialComponents


protocol LoginViewDelegate {
    func loadViewContentWithStage(stage: Stage)
    func loginAction(email: String, password: String)
}


class LoginViewController: UIViewController {

    var updateTFWithError: ((NSError) -> ())?
    var activeTF: UITextField?
    var delegate: LoginViewDelegate?
    @IBOutlet weak var revealPasswordBtn: UIButton!
    @IBOutlet weak var userNameTF: MDCTextField!
    @IBOutlet weak var passwordTF: MDCTextField!
    var userNameTFController: MDCTextInputControllerUnderline?
    var passwordTFController: MDCTextInputControllerUnderline?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
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
  
    @IBAction func signUpBtnTapped(_ sender: Any) {
        delegate?.loadViewContentWithStage(stage: .SignUpView)
    }
    
    
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        if(isValidInputValue().isValid)
        {
            updateTFWithError = { (error) in
                if(error.code == 401)
                {
                    self.passwordTFController?.setErrorText("Password is not correct", errorAccessibilityValue: nil)
                }
                else if(error.code == 404)
                {
                    self.userNameTFController?.setErrorText("Your account is not exist", errorAccessibilityValue: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            
            }
            delegate?.loginAction(email: isValidInputValue().email!.lowercased(), password: isValidInputValue().password!)
        }

    }
}


extension LoginViewController: UITextFieldDelegate
{
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
