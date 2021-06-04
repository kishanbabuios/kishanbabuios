//
//  BpOrangeQuestionnaireTableCell.swift
//  Care365-iPhone
//
//  Created by Apple on 07/05/21.
//

import UIKit

class BpOrangeQuestionnaireTableCell: UITableViewCell {

    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var yesAnsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.questionView.frame
        rectShape.position = self.questionView.center
        rectShape.path = UIBezierPath(roundedRect: self.questionView.bounds, byRoundingCorners: [ .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
       // rectShape.fillColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        //rectShape.borderColor =  UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        //rectShape.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        self.questionView.layer.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
       //self.questionView.backgroundColor = .systemBackground
        //Here I'm masking the textView's layer with rectShape layer
        self.questionView.layer.mask = rectShape
        
        
      // self.questionView.layer.borderWidth = 1
       // self.questionView.layer.borderColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
    // self.questionView.layer.cornerRadius = 10
        //self.questionView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        questionView.roundCorners(corners: [.bottomRight, .topRight], radius: 10.0)
//    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
