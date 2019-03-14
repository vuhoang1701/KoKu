//
//  LoginActionViewController.swift
//  Koku
//
//  Created by HoangVu on 3/8/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

enum Stage
{
    case LoginView
    case SignUpView
}

class LoginActionViewController: UIViewController {
    
    var stage:Stage?
    var loginView: LoginViewController!
    var signUpView: SIgnUpViewController!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stage = stage
        {
            loadViewContentWithStage(stage: stage)
        }
    }
    
    
    @IBAction func btnDismissBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

// PRAGMA MARK: - Login Delegate and SignUp delegate
extension LoginActionViewController: LoginViewDelegate, SIgnUpViewDelegate
{
    
    //Load content view with stage login/sign up
    func loadViewContentWithStage(stage: Stage)
    {
        switch stage {
        case .LoginView:
            if(loginView == nil)
            {
                loginView = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginView.willMove(toParent: self)
                contentView.addSubview(loginView.view)
                
                loginView.view.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(contentView).offset(0)
                    make.bottom.equalTo(contentView).offset(0)
                    make.left.equalTo(contentView).offset(0)
                    make.right.equalTo(contentView).offset(0)
                }
                loginView.delegate = self
                addChild(loginView)
                loginView.view.alpha = 0;
                loginView.didMove(toParent: self)
                contentView.bringSubviewToFront(loginView.view)
                loginView.view.isHidden = true
            
                
            }
            if(loginView.view.isHidden)
            {
                loginView.view.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.loginView.view.alpha = 1
                    if(self.signUpView != nil)
                    {
                        self.signUpView.view.alpha = 0
                        self.signUpView.view.isHidden = true
                    }
                }
            }
            break;
        case .SignUpView:
            if(signUpView == nil)
            {
                signUpView = SIgnUpViewController(nibName: "SIgnUpViewController", bundle: nil)
                signUpView.willMove(toParent: self)
                contentView.addSubview(signUpView.view)
                
                //Constraint for beginSearch view
                signUpView.view.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(contentView).offset(0)
                    make.bottom.equalTo(contentView).offset(0)
                    make.left.equalTo(contentView).offset(0)
                    make.right.equalTo(contentView).offset(0)
                }
                
                signUpView.delegate = self
                addChild(signUpView)
                signUpView.view.alpha = 0;
                signUpView.didMove(toParent: self)
                contentView.bringSubviewToFront(signUpView.view)
                signUpView.view.isHidden = true
            }
            if(signUpView.view.isHidden)
            {
                signUpView.view.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.signUpView.view.alpha = 1
                    if(self.loginView != nil)
                    {
                        self.loginView.view.alpha = 0
                        self.loginView.view.isHidden = true
                    }
                }
            }
            break;
        }
        
    }
    
    func loginAction(email: String, password: String) 
    {
        let loadingView = UIViewController.showLoading(onView: view)
        NetworkManager.login(email: email, password: password, success: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIViewController.hideLoading(view: loadingView)
                self.performSegue(withIdentifier: "showHomeView", sender: self)
            }
            
        }) { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIViewController.hideLoading(view: loadingView)
                self.loginView.updateTFWithError!(error)
            }
            
        }
       
    }
    
    func registerNewAccount(userModel: UserModel)
    {
        let loadingView = UIViewController.showLoading(onView: view)
        NetworkManager.signUpNewAccount(userModel: userModel, success: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIViewController.hideLoading(view: loadingView)
                self.performSegue(withIdentifier: "showFinalStep", sender: self)
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
