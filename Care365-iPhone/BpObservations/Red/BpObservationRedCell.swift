//
//  BpObservationRedCell.swift
//  Care365-iPhone
//
//  Created by Apple on 05/05/21.
//

import UIKit
import MKMagneticProgress
class BpObservationRedCell: UITableViewCell {

    @IBOutlet weak var bpRedAckView: UIView!
    @IBOutlet weak var bpRedAckLabel: UILabel!
    
    @IBOutlet weak var bpCreatedLabel: UILabel!
    @IBOutlet weak var bpRedMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var nextBpCheckupLabel: UILabel!
    
    @IBOutlet weak var nextBpCheckupDateLabel: UILabel!
    
    @IBOutlet weak var bpUnitsLabel: UILabel!
    
    @IBOutlet weak var bpRedHighAlertImageviewOne: UIImageView!
    
    @IBOutlet weak var bpTypeDescriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
