//
//  CustomTabBarController.swift
//  Koku
//
//  Created by HoangVu on 3/6/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit
import BubbleTransition

class CustomTabBarController: UITabBarController {

    let transition = BubbleTransition()
    var menuButton: UIButton!
    override func viewDidLoad() { // Called when tab bar loads
        super.viewDidLoad()
        // Sets up button
        connectSocket()
    }
    
    func setupMiddleButton() {
        var tabbarHeight: CGFloat = 0
     
        tabbarHeight = self.tabBar.frame.size.height
        
        let coverCenterTabbarItemView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width/3, height: tabbarHeight))
        var newFrame = coverCenterTabbarItemView.frame
        newFrame.origin.y = self.view.bounds.height - newFrame.height
        newFrame.origin.x = self.view.bounds.width/2 - newFrame.size.width/2
        coverCenterTabbarItemView.backgroundColor = UIColor.clear
        coverCenterTabbarItemView.frame = newFrame
        self.view.addSubview(coverCenterTabbarItemView)
        
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - tabbarHeight - 15
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = UIColor.colorWithHexString(hexString: "558FA6")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.setImage(UIImage(named: "transfer"), for: .normal) // 450 x 450px
        menuButton.contentMode = .scaleAspectFill
        self.view.addSubview(menuButton)
      
        
        let coverViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: tabbarHeight + 15))
        var coverViewButtonFrame = coverViewButton.frame
        coverViewButtonFrame.origin.y = self.view.bounds.height - coverViewButtonFrame.height
        coverViewButtonFrame.origin.x = self.view.bounds.width/2 - coverViewButtonFrame.size.width/2
        coverViewButton.frame = coverViewButtonFrame
        coverViewButton.backgroundColor = UIColor.clear
        coverViewButton.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        
     
        
        self.view.addSubview(coverViewButton)

    }
    
    override func viewDidLayoutSubviews() {
        if(menuButton == nil)
        {
            self.setupMiddleButton()
        }
    }
    
    func connectSocket()
    {
        SocketIOManager.sharedInstance.establishConnection {
            let userInfo = ["customId": UserSetting.sharedInstance.currentUser!.id!]
            SocketIOManager.sharedInstance.socket.emit("storeClientInfo",userInfo)
        }
    }
    
    
    @objc func menuButtonAction(sender: UIButton) {
        performSegue(withIdentifier: "presentSendMoneyView", sender: self)
    }


    @IBAction func dismissView(segue :UIStoryboardSegue) {
        
        
    }
    

}
