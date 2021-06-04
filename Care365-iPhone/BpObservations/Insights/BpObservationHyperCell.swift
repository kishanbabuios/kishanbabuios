//
//  BpObservationHyperCell.swift
//  Care365-iPhone
//
//  Created by Apple on 17/05/21.
//

import UIKit
import MKMagneticProgress
class BpObservationHyperCell: UITableViewCell {

    @IBOutlet weak var bpHyperMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var bpHyperCreatedAtLabel: UILabel!
    
    @IBOutlet weak var bpHyperImageView: UIImageView!
    
    @IBOutlet weak var bpHyperNextCheckupLabel: UILabel!
    
    @IBOutlet weak var bpHyperCheckupDateLabel: UILabel!
    
    @IBOutlet weak var bpHyperUnitsLabel: UILabel!
    
    @IBOutlet weak var bpHyperView: UIView!
    
    @IBOutlet weak var bpHyperImageViewTwo: UIImageView!
    
    @IBOutlet weak var bpHyperDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
