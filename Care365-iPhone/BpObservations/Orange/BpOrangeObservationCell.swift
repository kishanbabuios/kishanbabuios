//
//  BpOrangeObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 07/05/21.
//

import UIKit
import MKMagneticProgress
class BpOrangeObservationCell: UITableViewCell {

    @IBOutlet weak var bpOrangeMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var bpCreatedAtLabel: UILabel!
    
    @IBOutlet weak var bpOrangeNextCgeckupLabel: UILabel!
    
    @IBOutlet weak var bpOrangeNextCheckupDateLabel: UILabel!
    
    @IBOutlet weak var bpOrangeDescriptionLabel: UILabel!
    
    @IBOutlet weak var bpOrangeNextCheckupLabelTwo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
