//
//  QuestionnaireMajorSymptomsVcViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 03/05/21.
//

import UIKit
protocol MajorSymptomDelegate : AnyObject{
    func majorSymptomSelected(titleAlert : String)
}
class QuestionnaireMajorSymptomsVcViewController: UIViewController {

    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var symptonOneButton: QuestionnaireButton!
    
    @IBOutlet weak var symptomTwoButtton: QuestionnaireButton!
    
    @IBOutlet weak var symtomThreeButton: QuestionnaireButton!
    
    @IBOutlet weak var noneButton: QuestionnaireButton!
   weak var majorSymptomDelegate : MajorSymptomDelegate?
    
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        isWeightInputGiven = false
        self.navigationController?.isNavigationBarHidden = true
        self.questionView.layer.borderWidth = 1
        self.questionView.layer.borderColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0).cgColor
        self.questionView.layer.cornerRadius = 10
        self.questionView.layer.masksToBounds = true
        self.submitButton.isHidden = true
        
    }
    
    @IBAction func symptomAction(_ sender: UIButton) {
        self.majorSymptomDelegate?.majorSymptomSelected(titleAlert: (sender.titleLabel?.text)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noneAction(_ sender: UIButton) {
        self.submitButton.isHidden = false
        sender.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false) {
            let minorVc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "QuestionaaireViewController") as QuestionaaireViewController
            pvc?.modalPresentationStyle = .overFullScreen
            pvc?.present(UINavigationController(rootViewController: minorVc), animated: false, completion: nil)
        }
    }
}
