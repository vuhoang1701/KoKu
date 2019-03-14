//
//  ChangePasswordViewController.swift
//  Koku
//
//  Created by HoangVu on 3/10/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import MaterialComponents

class ChangePasswordViewController: UIViewController {
    
    var activeTF: UITextField?
    @IBOutlet weak var oldPasswordTF: MDCTextField!
    @IBOutlet weak var newPasswordTF: MDCTextField!
    @IBOutlet weak var confirmNewPasswordTF: MDCTextField!
    
    var oldPasswordTFController: MDCTextInputControllerUnderline?
    var newPasswordTFController: MDCTextInputControllerUnderline?
    var newPassword2TFController: MDCTextInputControllerUnderline?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpUI()
    {
        oldPasswordTF.delegate = self
        oldPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordTF.isSecureTextEntry = true
        oldPasswordTF.backgroundColor = .white
        oldPasswordTF.clearButtonMode = .never
        oldPasswordTFController = MDCTextInputControllerUnderline(textInput: oldPasswordTF)
        oldPasswordTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        oldPasswordTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        newPasswordTF.delegate = self
        newPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTF.isSecureTextEntry = true
        newPasswordTF.backgroundColor = .white
        newPasswordTF.clearButtonMode = .never
        newPasswordTFController = MDCTextInputControllerUnderline(textInput: newPasswordTF)
        newPasswordTFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        newPasswordTFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
        
        confirmNewPasswordTF.delegate = self
        confirmNewPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        confirmNewPasswordTF.isSecureTextEntry = true
        confirmNewPasswordTF.backgroundColor = .white
        confirmNewPasswordTF.clearButtonMode = .never
        newPassword2TFController = MDCTextInputControllerUnderline(textInput: confirmNewPasswordTF)
        newPassword2TFController?.activeColor = UIColor.colorWithHexString(hexString: "558FA6")
        newPassword2TFController?.floatingPlaceholderActiveColor = UIColor.colorWithHexString(hexString: "558FA6")
    }
    
    func isValidInputValue() -> Bool
    {
        if let oldPassword = oldPasswordTF.text
        {
            if(oldPassword == "")
            {
                oldPasswordTFController?.setErrorText("Please input current password", errorAccessibilityValue: nil)
                return false
            }
            else if(oldPassword != UserSetting.sharedInstance.currentUser?.password!)
            {
                oldPasswordTFController?.setErrorText("Current password is not correct", errorAccessibilityValue: nil)
                return false
            }
            
        }
        
        if let newPassword = newPasswordTF.text
        {
            if(newPassword == "")
            {
                newPasswordTFController?.setErrorText("Please input new password", errorAccessibilityValue: nil)
                return false
            }
            else if(newPassword == UserSetting.sharedInstance.currentUser?.password!)
            {
                newPasswordTFController?.setErrorText("New password is the same with old password", errorAccessibilityValue: nil)
                return false
            }
            
        }
        if let confirmPassword = confirmNewPasswordTF.text
        {
            if(confirmPassword == "")
            {
                newPassword2TFController?.setErrorText("Please confirm new password", errorAccessibilityValue: nil)
                return false
            }
            else if(confirmPassword != newPasswordTF.text!)
            {
                newPassword2TFController?.setErrorText("Confirm password does not match", errorAccessibilityValue: nil)
                return false
            }
        }
        
        return true
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
        var selectedTF: MDCTextField!
        switch senderButton!.tag {
        case 1:
            selectedTF = oldPasswordTF
            break
        case 2:
            selectedTF = newPasswordTF
            break
        case 3:
            selectedTF = confirmNewPasswordTF
            break
        default:
            break
        }
        
        selectedTF.isSecureTextEntry = !selectedTF.isSecureTextEntry
        if let textRange = selectedTF.textRange(from: selectedTF.beginningOfDocument, to: selectedTF.endOfDocument) {
            if( selectedTF.isSecureTextEntry)
            {
                senderButton?.setImage(UIImage(named: "Eye"), for: .normal)
            }
            else
            {
                selectedTF.replace(textRange, withText: selectedTF.text!)
                senderButton?.setImage(UIImage(named: "Eye-Out-Time"), for: .normal)
            }
            
        }
        
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        if(isValidInputValue())
        {
            if let modelWithNewPassword = UserSetting.sharedInstance.currentUser?.copy() as? UserModel
            {
                modelWithNewPassword.password = newPasswordTF.text
                let loadingView = UIViewController.showLoading(onView: view)
                NetworkManager.updateAccountDetail(userModel: modelWithNewPassword, success: {
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
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField as? MDCTextField == oldPasswordTF)
        {
            oldPasswordTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == newPasswordTF)
        {
            newPasswordTFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        else if (textField as? MDCTextField == confirmNewPasswordTF)
        {
            newPassword2TFController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
