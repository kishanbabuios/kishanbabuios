//
//  BpOrangeFirstTimeObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 10/05/21.
//

import UIKit
import MKMagneticProgress
class BpOrangeFirstTimeObservationCell: UITableViewCell {

    @IBOutlet weak var bpOrangeMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var bpOrangeLastCreatedLabel: UILabel!
    
    @IBOutlet weak var bpOrangeNextCheckupLabel: UILabel!
    
    @IBOutlet weak var bpOrangeNextCheckupDateLabel: UILabel!
    
    @IBOutlet weak var bpOrangeDescriptionLabel: UILabel!
    
    @IBOutlet weak var bpOrangeBreathingExerciseLabel: UILabel!
    
    @IBOutlet weak var bpOrangeVideoButton: UIButton!
    
    @IBOutlet weak var bpOrangeNextBpCheckupLabelTwo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bpOrangeVideoAction(_ sender: UIButton) {
    }
}
