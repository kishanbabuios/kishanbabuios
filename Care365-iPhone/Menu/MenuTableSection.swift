//
//  MenuTableSection.swift
//  Care365-iPhone
//
//  Created by Apple on 01/04/21.
//

import UIKit
protocol MenuSectionDelegate {
    func didSelectSection(section:Int)
}
class MenuTableSection: UITableViewHeaderFooterView {
     var menuSectionDelegate : MenuSectionDelegate?
    @IBOutlet weak var sectionImageView: UIImageView!
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBAction func sectionAction(_ sender: UIButton) {
        menuSectionDelegate?.didSelectSection(section: sender.tag)
    }
}
