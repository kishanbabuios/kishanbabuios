//
//  QuestionnaireTableCell.swift
//  Care365-iPhone
//
//  Created by Apple on 03/05/21.
//

import UIKit

class QuestionnaireTableCell: UITableViewCell {
    @IBOutlet weak var queLabel: UILabel!
    @IBOutlet weak var queView: UIView!
    @IBOutlet weak var yesOrNoLabel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.queView.frame
        rectShape.position = self.queView.center
        rectShape.path = UIBezierPath(roundedRect: self.queView.bounds, byRoundingCorners: [ .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
       // rectShape.fillColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        //rectShape.borderColor =  UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        //rectShape.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        self.queView.layer.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
       //self.questionView.backgroundColor = .systemBackground
        //Here I'm masking the textView's layer with rectShape layer
        self.queView.layer.mask = rectShape
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
