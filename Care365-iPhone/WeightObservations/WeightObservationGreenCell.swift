//
//  WeightObservationGreenCell.swift
//  Care365-iPhone
//
//  Created by Apple on 12/05/21.
//

import UIKit
import MKMagneticProgress
class WeightObservationGreenCell: UITableViewCell {

    @IBOutlet weak var weightGreenMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var weightGreenCreatedAtLabel: UILabel!
    
    @IBOutlet weak var weightGreenImageView: UIImageView!
    
    @IBOutlet weak var weightGreenNextCheckupLabel: UILabel!
    
    @IBOutlet weak var weightGreenNextCheckupDateLabel: UILabel!
    
    @IBOutlet weak var weightGreenAckView: UIView!
    
    @IBOutlet weak var weightGreenImageViewTwo: UIImageView!
    
    @IBOutlet weak var weightGreenAckLabel: UILabel!
    
    @IBOutlet weak var weightGreenAckViewTwo: UIView!
    
    @IBOutlet weak var weightGreenLastDialysisLabel: UILabel!
    
    @IBOutlet weak var weightGreenGainedLabel: UILabel!
    
    @IBOutlet weak var weightGreenPermittedWeightGainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
