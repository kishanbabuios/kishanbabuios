//
//  Utility.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import Foundation
import UIKit
import Alamofire
struct Utility {
    static func isConnectedToInternet() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}

class CardView: UIView {
    override func layoutSubviews() {
        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.systemBackground.cgColor
        updateShadowPath()
    }
    func updateShadowPath() {
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: 5, height: 5)).cgPath
        self.layer.shouldRasterize = true
    }
}

class DottedView: UIView {
    override func layoutSubviews() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 1.0/255, green: 0/255, blue: 102/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

class QuestionnaireButton: UIButton {
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
          }
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
          }
     func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1).cgColor
//        self.backgroundColor = UIColor(red: 233/255, green: 245/255, blue: 253/255, alpha: 1)
        self.backgroundColor = .green
        self.layer.cornerRadius = 12
        self.backgroundColor = .clear
        self.titleLabel?.textColor = UIColor(red: 0.153, green: 0.137, blue: 0.369, alpha: 1)
        self.layer.masksToBounds = true
       
    }
    
}

enum Zone : Int {
    case red_flag = 1
    case orange_flag = 2
    case green_flag = 3
    case non_adherence = 4
    case gray_flag = 5
}

enum SubmitActionVc : String{
    case insightsVc = "insights"
    case emergencyVc = "emergency"
}

