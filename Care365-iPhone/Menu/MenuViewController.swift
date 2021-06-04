//
//  MenuViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 30/03/21.
//

import UIKit
import SideMenuSwift

class MenuViewController: UIViewController {
    var patientInstance : Patient?
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    var hiddenSections = Set<Int>()
    var sectionTableArray = ["Clinical Details","Dialysis center","Doctor","Insurance","Device Info"]
    var sectionImageArray = ["Clinical Details","Dialysis Centre","Doctor","Insurance","Device Info"]
    
    var tableData = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        usrDefaults.setValue(true, forKey: "LoggedIn")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") }, with: "first")
        sideMenuController?.setContentViewController(with: "first")
       
        self.initialSetUp()
        let nib = UINib(nibName:"MenuTableSection", bundle: nil)
        self.menuTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
            for i in 0..<self.sectionTableArray.count{
            self.hiddenSections.insert(i)
                self.menuTableView.deleteRows(at: self.indexpathByDefault(),
                                          with:.fade)
        }
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        usrDefaults.setValue(false, forKey: "LoggedIn")
        //Removing All the keys Stored in UserDefaults
        DispatchQueue.global(qos: .userInitiated).async {
            for key in usrDefaults.dictionaryRepresentation().keys {
                if key.description == "LoggedIn"{
                    print(key.description)
                }else{
                    usrDefaults.removeObject(forKey: key.description)
                }
            }
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    /// method to setup basicUi and functionality
    func initialSetUp()  {
        self.menuTableView.separatorStyle = .none
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        guard let firstName = patientInstance?.firstName else { return }
        guard let lastname = patientInstance?.lastName else { return }
        guard let age = patientInstance?.age else { return }
        guard let gender = patientInstance?.gender else { return }
        self.nameAgeLabel.text = "\(firstName) \(lastname) (\(age)/\(gender))"
        self.patientIdLabel.text = patientInstance?.id
        if let emr = patientInstance?.emrPatientId{
            self.emrIdLabel.text = "EMR Id : \(emr)"
        }
        self.emailIdLabel.text = patientInstance?.care365Email
        self.mobileNumberLabel.text = patientInstance?.cellNumber
        guard let adressLine = patientInstance?.address?.addressLine else { return }
        guard let city = patientInstance?.address?.city else { return }
        guard let state = patientInstance?.address?.state else { return }
        guard let zipcode = patientInstance?.address?.zipCode else { return }
        self.addressLabel.text = adressLine + " " + city + " " + state + " " + String(zipcode)
        guard let primaryDiagnosis = patientInstance?.primaryDiagnosis else { return }
        guard let secondaryDiagnosis = patientInstance?.secondaryDiagnosis else { return }
        guard let height = patientInstance?.height else { return }
        guard let dryWeight = patientInstance?.dryWeight else { return }
        guard let systolicBloodPressure = patientInstance?.systolicBloodPressure else { return }
        guard let diastolicBloodPressure = patientInstance?.diastolicBloodPressure else { return }
        let baseLineBp = "\(systolicBloodPressure)/\(diastolicBloodPressure)"
        let clinicalArray = [primaryDiagnosis,secondaryDiagnosis,height,dryWeight,baseLineBp]
        tableData.append(clinicalArray)
        
        guard let dialysisName = patientInstance?.branch?.name else { return }
        let dialysisCenterArray = [dialysisName]
        tableData.append(dialysisCenterArray)
        
        guard let doctorName = patientInstance?.primaryPhysician?.name else { return }
        let doctorArray = [doctorName]
        tableData.append(doctorArray)
       
        guard let insuranceName = patientInstance?.insuranceData?.medicareAdvantageInsurer else { return }
        guard let insuranceNo = patientInstance?.insuranceData?.medicareNumber else { return }
        let insuranceArray = [insuranceNo,insuranceName]
        tableData.append(insuranceArray)
        
        let deviceArray = ["Dev-120","Dev-119"]
        tableData.append(deviceArray)
        PrintLog.print(tableData.count)
        PrintLog.print(tableData)
    }
    
    func indexpathByDefault()  -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in 0..<self.tableData[0].count {
            indexPaths.append(IndexPath(row: row,
                                        section: 0))
        }
        return indexPaths
    }
    
    
    
   
}
extension MenuViewController:UITableViewDelegate,UITableViewDataSource,MenuSectionDelegate{
    /// method for menu sectionDelegate
    /// - Parameter section: section Integer Value
    func didSelectSection(section: Int) {
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            for row in 0..<self.tableData[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.menuTableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.menuTableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        PrintLog.print(section)
        PrintLog.print(tableData[section].count)
        return self.tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell
        cell.isUserInteractionEnabled = false
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.menuLabel.text = "Primary Diagnosis : \(self.tableData[indexPath.section][indexPath.row])"
            case 1:
                cell.menuLabel.text = "Secondary Diagnosis : \(self.tableData[indexPath.section][indexPath.row])"
            case 2:
                cell.menuLabel.text = "Height : \(self.tableData[indexPath.section][indexPath.row]) cm"
            case 3:
                cell.menuLabel.text = "Dry Weight : \(self.tableData[indexPath.section][indexPath.row]) kg"
            default:
                cell.menuLabel.text = "BaseLine BP : \(self.tableData[indexPath.section][indexPath.row]) mmHg"
            }
        }else if indexPath.section == 3{
            switch indexPath.row {
            case 0:
                cell.menuLabel.text = "Insurance No : \(self.tableData[indexPath.section][indexPath.row])"
            default:
                cell.menuLabel.text = "Insurance Name : \(self.tableData[indexPath.section][indexPath.row])"
            }
        }else if indexPath.section == 4{
            switch indexPath.row {
            case 0:
                cell.menuLabel.text = "Weight Device Id: \(self.tableData[indexPath.section][indexPath.row])"
            default:
                cell.menuLabel.text = "BP Device Id : \(self.tableData[indexPath.section][indexPath.row])"
            }
        } else{
            cell.menuLabel.text = self.tableData[indexPath.section][indexPath.row]
        }
        cell.contentView.backgroundColor = UIColor(red: 206/255, green: 233/255, blue: 255/255, alpha: 1.0)
        cell.menuLabel.textColor = UIColor(red: 39/255, green: 35/255, blue: 94/255, alpha: 1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 80
            case 1:
                return 80
            default:
                return UITableView.automaticDimension
            }
        }else {
            return UITableView.automaticDimension
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTableArray.count
    }
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! MenuTableSection
        header.sectionTitleLabel.text = self.sectionTableArray[section]
        header.sectionImageView.image = UIImage(named:self.sectionImageArray[section] )
        header.backgroundView?.backgroundColor = .systemBackground
        header.sectionButton.tag = section
        header.menuSectionDelegate = self
        return header
    }
}
