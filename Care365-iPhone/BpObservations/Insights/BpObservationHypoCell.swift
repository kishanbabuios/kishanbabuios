//
//  BPObservationRedInsightCell.swift
//  Care365-iPhone
//
//  Created by Apple on 07/05/21.
//

import UIKit
import MKMagneticProgress
class BpObservationHypoCell: UITableViewCell {

    @IBOutlet weak var bpRedMagneticProgressView: MKMagneticProgress!
    
    @IBOutlet weak var bpCreatedAtLabel: UILabel!
    @IBOutlet weak var bpRedNextChekupLabel: UILabel!
    
    @IBOutlet weak var bpRedUnitsLabel: UILabel!
    @IBOutlet weak var bpRedNextCheckupDateLabel: UILabel!
    @IBOutlet weak var bpHypoImageViewTwo: UIImageView!
    
    @IBOutlet weak var bpRedDescriptionLabel: UILabel!
    
    @IBOutlet weak var bpHypoView: UIView!
    
    @IBOutlet weak var bpHypoImageView: UIImageView!
    
    @IBOutlet weak var bpHypoDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
