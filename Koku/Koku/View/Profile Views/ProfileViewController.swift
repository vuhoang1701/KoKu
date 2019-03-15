//
//  ProfileViewController.swift
//  Koku
//
//  Created by HoangVu on 3/10/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var fullNameLbel: UILabel!
    @IBOutlet weak var roleLbel: UILabel!
    @IBOutlet weak var userIdLbel: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var numTransLbel: UILabel!
    @IBOutlet weak var fullNameDetailLbel: UILabel!
    @IBOutlet weak var emailDetailLbel: UILabel!
    @IBOutlet weak var phoneNumberDetailLbel: UILabel!
    @IBOutlet weak var countryDetailLbel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parseDataToUI()
    }
    
    func parseDataToUI()
    {
        if let firstName = UserSetting.sharedInstance.currentUser?.firstName, let lastName = UserSetting.sharedInstance.currentUser?.lastName
        {
            
            fullNameLbel.text = firstName.trimmingCharacters(in: .whitespaces) + " " + lastName.trimmingCharacters(in: .whitespaces)
            fullNameDetailLbel.text = fullNameLbel.text
            if let fullname = fullNameLbel.text
            {
                
                let stringInputArr = fullname.components(separatedBy:" ")
                var stringNeed = ""
                
                for string in stringInputArr {
                    stringNeed = stringNeed + String(string.first!).uppercased()
                }
                avatarBtn.setTitle(stringNeed, for: .normal)
                
            }
        }
        else
        {
            fullNameLbel.text = UserSetting.sharedInstance.currentUser?.email
            if let fullname = fullNameLbel.text
            {
                
                let stringInputArr = fullname.components(separatedBy:" ")
                var stringNeed = ""
                
                for string in stringInputArr {
                    stringNeed = stringNeed + String(string.first!).uppercased()
                }
                avatarBtn.setTitle(stringNeed, for: .normal)
                
            }
        }
        roleLbel.text = "\((UserSetting.sharedInstance.currentUser?.role)!) User"
        userIdLbel.text = "User Id: \((UserSetting.sharedInstance.currentUser?.id)!)"
        if let email = UserSetting.sharedInstance.currentUser?.email
        {
            emailDetailLbel.text = email
        }
        
        if let phoneNumber = UserSetting.sharedInstance.currentUser?.phoneNumber
        {
            phoneNumberDetailLbel.text = phoneNumber
        }
        
        if let country = UserSetting.sharedInstance.currentUser?.country
        {
            countryDetailLbel.text = country
        }
        
    }


    @IBAction func logout(_ sender: Any) {
        AppDelegate.sharedInstance?.logout()
        dismiss(animated: true) {
           if(!(AppDelegate.sharedInstance?.getTopViewController() is CustomLoginViewController))
           {
            AppDelegate.sharedInstance?.getTopViewController().dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
