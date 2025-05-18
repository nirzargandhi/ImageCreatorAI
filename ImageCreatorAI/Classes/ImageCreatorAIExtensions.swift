//
//  ImageCreatorAIExtensions.swift
//  ImageCreatorAI
//
//  Created by Nirzar Gandhi on 16/05/25.
//

import Foundation
import UIKit

// MARK: - UIViewController
extension UIViewController {
    
    // Add Navigation Bottom Shadow
    func hideNavigationBottomShadow() {
        self.navigationController?.navigationBar.layer.masksToBounds = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
    }
    
    // Get Top & Bottom bar height
    var getNavBarHeight: CGFloat {
        return (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var getTabBarHeight: CGFloat {
        return (self.tabBarController?.tabBar.frame.size.height ?? 49.0)
    }
    
    // Show Alert Message
    func showAlertMessage(titleStr: String, messageStr: String) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}


// MARK: - UIView
extension UIView {
    
    func addRadiusWithBorder(radius: CGFloat = 10, border: CGFloat = 0.0) {
        
        self.layer.cornerRadius = radius
        if #available(iOS 13.0, *) {
            self.layer.cornerCurve = .continuous
        }
        self.layer.borderWidth = border
    }
}

// MARK: - UITextField
extension UITextField {
    
    func setLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


// MARK: - UIButton
extension UIButton {
    
    // Set BackgroundColor
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}


// MARK: - UIDevice
extension UIDevice {
    
    var hasNotch: Bool {
        let bottom = WINDOWSCENE?.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
