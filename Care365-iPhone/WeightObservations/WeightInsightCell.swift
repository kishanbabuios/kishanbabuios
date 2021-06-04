//
//  WeightInsightCell.swift
//  Care365-iPhone
//
//  Created by Apple on 18/05/21.
//

import UIKit
import MKMagneticProgress
class WeightInsightCell: UITableViewCell {

    
    @IBOutlet weak var weightMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var weightLastCreatedatLabel: UILabel!
    
    @IBOutlet weak var weightObservationImageView: UIImageView!
    
    
    @IBOutlet weak var weightNextCheckupLabel: UILabel!
    
    @IBOutlet weak var weightNextCheckupDateLabel: UILabel!
    
    @IBOutlet weak var weightMainAckView: UIView!
    
    @IBOutlet weak var weightObservationImageViewTwo: UIImageView!
    
    @IBOutlet weak var weightDescriptionLabel: UILabel!
    
    @IBOutlet weak var weightExtradialysisLabel: UILabel!
    
    
    @IBOutlet weak var WeightTimeSinceLastDiaLabel: UILabel!
    
    
    @IBOutlet weak var weightGainedLabel: UILabel!
    
    @IBOutlet weak var permittedView: UIView!
    
    @IBOutlet weak var permittedWeightGainLabel: UILabel!
    
    @IBOutlet weak var weightActionableInsightsView: UIView!
    
    @IBOutlet weak var weightObservationImageViewThree: UIImageView!
    
    @IBOutlet weak var weightDescriptionLabelTwo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
