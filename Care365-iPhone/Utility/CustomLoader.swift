//
//  CustomLoader.swift
//  SampleDemo
//
//  Created by guruprasad gudluri on 05/01/20.
//  Copyright © 2020 Sai. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerUtils  {
    static let shared = ViewControllerUtils()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    var imageLoader : UIImageView = UIImageView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    /*
        Show customized activity indicator,
        actually add activity indicator to passing view
    
        @param uiView - add activity indicator to this view
    */
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.5)//UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
    
        loadingView.frame = CGRect(x:0, y:0, width:100, height:100)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.clear//UIColorFromHex(rgbValue: 0x444444, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        //imageLoader.frame = CGRect(x:0.0, y:0.0, width:80, height:80);
        //imageLoader.loadGif(name: "loader")
        activityIndicator.style = .large
        //activityIndicator.color = UIColor(red: 11/255, green: 138/255, blue: 255/255, alpha: 1.0)
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        activityIndicator.hidesWhenStopped = true
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    /*
        Hide activity indicator
        Actually remove activity indicator from its super view
    
        @param uiView - remove activity indicator from this view
    */
    func hideActivityIndicator(uiView: UIView) {
            self.container.removeFromSuperview()
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
