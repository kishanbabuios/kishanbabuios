//
//  BpObservationRedCell.swift
//  Care365-iPhone
//
//  Created by Apple on 05/05/21.
//

import UIKit
import MKMagneticProgress
class BpObservationEmergencyCell: UITableViewCell {

    @IBOutlet weak var bpRedMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var bpRedCreatedAtLabel: UILabel!
    
    @IBOutlet weak var bpRedNextCheckupLabel: UILabel!
    @IBOutlet weak var bpRedDescriptionLabel: UILabel!
    
    @IBOutlet weak var bpRedNextCheckupDateLabel: UILabel!
    @IBOutlet weak var bpRedSymtomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
