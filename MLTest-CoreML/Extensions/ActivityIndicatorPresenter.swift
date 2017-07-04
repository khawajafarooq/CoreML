//
//  ActivityIndicatorPresenter.swift
//  MLTest-CoreML
//
//  Created by GIB on 7/3/17.
//  Copyright © 2017 Xmen. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresenter {
    var container: UIView { get }
    var loadingView: UIView { get }
    var activityIndicator: UIActivityIndicatorView { get }
    
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator() {
        self.container.frame = self.view.frame
        self.container.center = self.view.center
        self.container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.loadingView.center = self.view.center
        self.loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicator.center = CGPoint(x: self.loadingView.frame.size.width / 2,
                                           y: self.loadingView.frame.size.height / 2)
        
        self.loadingView.addSubview(self.activityIndicator)
        self.container.addSubview(self.loadingView)
        self.view.addSubview(self.container)
        self.activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.container.removeFromSuperview()
        
        if let theView = self.view.viewWithTag(1021) {
            theView.removeFromSuperview()
        }
        
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
