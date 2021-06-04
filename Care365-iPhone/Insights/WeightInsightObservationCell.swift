//
//  WeightInsightObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 14/04/21.
//

import UIKit

class WeightInsightObservationCell: UITableViewCell {
    @IBOutlet weak var weightInsightZoneView: UIView!
    
    @IBOutlet weak var weightDescriptionLabel: UILabel!
    @IBOutlet weak var weightInsightZoneImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.weightDescriptionLabel.text = "You have gained \(weightGainedDefaults) kg in \(timeLastDial)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
