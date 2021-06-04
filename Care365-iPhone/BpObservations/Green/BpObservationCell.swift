//
//  BpObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 07/04/21.
//

import UIKit
import MKMagneticProgress
class BpObservationCell: UITableViewCell {

    @IBOutlet weak var bpTitleLabel: UILabel!
    @IBOutlet weak var bpMagneticProgress: MKMagneticProgress!
    
    @IBOutlet weak var bpUnitsLabel: UILabel!
    @IBOutlet weak var bpCreatedLabel: UILabel!
    
    @IBOutlet weak var bpAcknowledgeImageView: UIImageView!
    
    @IBOutlet weak var bpNextCheckupLabel: UILabel!
    
    @IBOutlet weak var bpNextCheckupDateLabel: UILabel!
    
   
    
    @IBOutlet weak var bpAcknowledgeView: UIView!
    
    @IBOutlet weak var bpNextCheckupLabelTwo: UILabel!
    @IBOutlet weak var bpAcknowledgeImageTwo: UIImageView!
    
   
    @IBOutlet weak var bpAcknowledgeLabel: UILabel!
    
    @IBOutlet weak var bpAcknowledgeViewTwo: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func call911Action(_ sender: UIButton) {
    }
}
