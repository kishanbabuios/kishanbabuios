//
//  InsightViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 09/04/21.
//

import UIKit

class InsightViewController: UIViewController {
    var insightType = ""
    var bpType = ""
    var zoneValue = 0
    weak var weightRedSymptomDelegate : WeightRedSymptomDelegate?
    @IBOutlet weak var insightTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.insightTableView.delegate = self
        self.insightTableView.dataSource = self
    }
    
    @IBAction func understandAction(_ sender: UIButton) {
        if self.insightType == InsightType.weight {
            
            self.dismiss(animated: true, completion: nil)
        }else{
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension InsightViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch self.insightType {
        case InsightType.bp:
            if self.bpType == BpType.HYPO {
                let bpInsightNib = UINib(nibName:"HypoInsightCell", bundle: nil)
                self.insightTableView.register(bpInsightNib, forCellReuseIdentifier: "HypoInsightCell")
                let current
                    = tableView.dequeueReusableCell(withIdentifier: "HypoInsightCell", for: indexPath) as! HypoInsightCell
                current.bpAckLabel.text = BpDescriptionType.bpHypoDescription
                if self.zoneValue == 1 {
                    current.bpAckView.backgroundColor = .red
                    current.bpAckImageView.image = CRImages.whiteHighAlertIcon
                    
                }else if self.zoneValue == 2{
                    current.bpAckView.backgroundColor = .orange
                    current.bpAckImageView.image = CRImages.whiteAlertIcon
                }
                cell = current
            }else if self.bpType == BpType.HYPER {
                let bpInsightNib = UINib(nibName:"HyperInsightCell", bundle: nil)
                self.insightTableView.register(bpInsightNib, forCellReuseIdentifier: "HyperInsightCell")
                let current
                    = tableView.dequeueReusableCell(withIdentifier: "HyperInsightCell", for: indexPath) as! HyperInsightCell
                current.bpAckLabel.text = BpDescriptionType.bpHypoDescription
                if self.zoneValue == 1 {
                    current.bpAckView.backgroundColor = .red
                    current.bpAckImageView.image = CRImages.whiteHighAlertIcon
                    
                }else if self.zoneValue == 2{
                    current.bpAckView.backgroundColor = .orange
                    current.bpAckImageView.image = CRImages.whiteAlertIcon
                }
                cell = current
                
            }
            
        default:
            let weightInsightNib = UINib(nibName:"WeightInsightObservationCell", bundle: nil)
            self.insightTableView.register(weightInsightNib, forCellReuseIdentifier: "WeightInsightObservationCell")
            let current
                = tableView.dequeueReusableCell(withIdentifier: "WeightInsightObservationCell", for: indexPath) as! WeightInsightObservationCell
            if self.zoneValue == 2 {
                current.weightInsightZoneView.backgroundColor = .orange
                current.weightInsightZoneImageView.image = CRImages.whiteAlertIcon
                current.weightDescriptionLabel.text = "You have gained \(weightGainedDefaults) kg in \(timeLastDial) Hrs"
            }else if self.zoneValue == 1{
                current.weightInsightZoneView.backgroundColor = .red
                current.weightInsightZoneImageView.image = CRImages.whiteHighAlertIcon
                current.weightDescriptionLabel.text = "You have gained \(weightGainedDefaults) kg in \(timeLastDial) Hrs"
            }
            cell = current
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
