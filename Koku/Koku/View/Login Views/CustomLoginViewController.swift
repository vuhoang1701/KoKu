//
//  CustomLoginViewController.swift
//  Koku
//
//  Created by HoangVu on 3/7/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//
import Lottie
import UIKit
import SnapKit

class CustomLoginViewController: UIViewController {

    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    var lottieExchange: LOTAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        UserSetting.sharedInstance.loadCurrentUserFromUserDefault()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let loggedUser = UserSetting.sharedInstance.currentUser
        {
            loginAction(email: loggedUser.email, password: loggedUser.password!)
        }
    }

    func setUpUI()
    {
        signupBtn.layer.borderColor = UIColor.colorWithHexString(hexString: "#59E3FF").cgColor
        signupBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = UIColor.colorWithHexString(hexString: "#59E3FF").cgColor
        loginBtn.layer.borderWidth = 1;
        lottieExchange = LOTAnimationView(name: "exchange")
        lottieView.addSubview(lottieExchange!)
        lottieExchange?.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(lottieView).offset(0)
            make.bottom.equalTo(lottieView).offset(0)
            make.left.equalTo(lottieView).offset(0)
            make.right.equalTo(lottieView).offset(0)
        })
        lottieExchange?.animationSpeed = 1.5;
        
       
    }
    
    //Login action with animate
    @IBAction func loginBtnTapped(_ sender: Any) {
        lottieExchange?.play(fromProgress: 0.3, toProgress: 1, withCompletion: { (bool) -> Void in
            self.performSegue(withIdentifier: "presentLoginAction", sender: self)
        })
    }
    
    //Sign up action with animate
    @IBAction func signUpBtnTapped(_ sender: Any) {
        lottieExchange?.play(fromProgress: 0.3, toProgress: 1, withCompletion: { (bool) -> Void in
            self.performSegue(withIdentifier: "presentSignUpAction", sender: self)
        })
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentLoginAction"
        {
            let loginActionView = segue.destination as? LoginActionViewController
            loginActionView?.stage = Stage.LoginView
            
        }
        if segue.identifier == "presentSignUpAction"
        {
            let signUpActionView = segue.destination as? LoginActionViewController
            signUpActionView?.stage = Stage.SignUpView

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
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        }
        
    }

}



