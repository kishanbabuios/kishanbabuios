//
//  BpInsightObservationCell.swift
//  Care365-iPhone
//
//  Created by Apple on 04/05/21.
//

import UIKit

class HyperInsightCell: UITableViewCell {

   
    @IBOutlet weak var bpAckView: UIView!
    @IBOutlet weak var bpAckImageView: UIImageView!
    @IBOutlet weak var bpAckLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
