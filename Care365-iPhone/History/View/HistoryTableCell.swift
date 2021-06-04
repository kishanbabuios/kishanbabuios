//
//  HistoryTableCell.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import UIKit

class HistoryTableCell: UITableViewCell {

    @IBOutlet weak var systolicLabel: UILabel!
    @IBOutlet weak var diastolicLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
