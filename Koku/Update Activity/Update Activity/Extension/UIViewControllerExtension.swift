//
//  UIViewControllerExtension.swift
//  Koku
//
//  Created by HoangVu on 3/9/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import SnapKit

extension UIViewController {
    
    class func showLoading(onView: UIView) -> UIView {
        let backgroundView = UIView.init(frame: onView.bounds)
        
        backgroundView.backgroundColor = UIColor.colorWithHexString(hexString: "558FA6")
        backgroundView.alpha = 0.9
        var lottieLoading: LOTAnimationView?
        lottieLoading = LOTAnimationView(name: "loading")
        onView.addSubview(backgroundView)
        backgroundView.addSubview(lottieLoading!)
        lottieLoading?.snp.makeConstraints({ (make) -> Void in
            make.centerY.centerX.equalTo(backgroundView)
            make.width.equalTo(backgroundView.frame.width)
        })
        lottieLoading?.contentMode = .scaleAspectFit
        lottieLoading?.animationSpeed = 2;
  
        DispatchQueue.main.async {

            lottieLoading?.play()
            lottieLoading?.loopAnimation = true
        }
        
        return backgroundView
    }
    
    class func hideLoading(view: UIView) {
        DispatchQueue.main.async {
            view.removeFromSuperview()
        }
    }
    
    
}
