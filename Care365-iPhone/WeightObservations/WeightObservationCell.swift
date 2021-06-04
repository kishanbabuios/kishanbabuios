//
//  WeightObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 07/04/21.
//

import UIKit
import MKMagneticProgress
class WeightObservationCell: UITableViewCell {

    @IBOutlet weak var weightMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var weightLastCreatedAtLabel: UILabel!
    
    @IBOutlet weak var weightObservationImageView: UIImageView!
    @IBOutlet weak var weightNextCheckupLabel: UILabel!
    
    @IBOutlet weak var weightNextCheckupDateLabel: UILabel!
    
    @IBOutlet weak var weightMainAckView: UIView!
    
    @IBOutlet weak var weightObservationImageViewTwo: UIImageView!
    
    @IBOutlet weak var weightDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var extraDialysisLabel: UILabel!
    
    @IBOutlet weak var WeightTimeSinceLastDiaLabel: UILabel!
    
    @IBOutlet weak var weightGainedLabel: UILabel!
    
    @IBOutlet weak var permittedView: UIView!
    
    @IBOutlet weak var permittedWeightGainLAbel: UILabel!
    
    
    @IBOutlet weak var call911View: UIView!
    
    @IBOutlet weak var emergencyDescriptionLabel: UILabel!
    
    @IBOutlet weak var call911Button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func call911Action(_ sender: UIButton) {
    }
}
