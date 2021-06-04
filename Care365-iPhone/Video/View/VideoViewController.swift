//
//  VideoViewController.swift
//  Care365-iOS
//
//  Created by Apple on .
//

import UIKit
import SideMenuSwift
import AVKit
class VideoViewController: UIViewController {
    @IBOutlet weak var videoTableView: UITableView!
    let titleArray = ["How to Check Weight?","How to check Blood pressure?","How to do breathing exercise?", "How to do ankle pump exercise?"]
    let videoArray = [VideoUrl.weightMeasureUrl, VideoUrl.bpMeasureUrl,VideoUrl.breathingExerciseUrl,VideoUrl.anklePumpUrl]
    var thumbNailArry = [UIImage]()
    let videoViewModel = VideoViewModel()
    var delay = 1.0
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTableView.backgroundView?.backgroundColor = .clear
        self.videoTableView.separatorStyle = .none
        self.videoTableView.delegate = self
        self.videoTableView.dataSource = self
       // self.showIndicator()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.hideIndicator()
//        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func getInfoAction(_ sender: UIButton) {
        guard let vc = StoryBoards.homeStoryBoard.instantiateViewController(identifier: "InformationViewController") as? InformationViewController else {return}
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
extension VideoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoTableCell
        cell.videoTitleLabel.text = titleArray[indexPath.row]
        //action runnning on background thread
//        DispatchQueue.global(qos: .background).async {
//            if let videoURL = URL(string: self.videoArray[indexPath.row]){
//                    let thumb = self.createVideoThumbnail(from: videoURL)
//                        self.thumbNailArry.append(thumb!)
//
//            }
//            //ui running on main thread
//            DispatchQueue.main.async {
//                cell.videoImageView.image = self.thumbNailArry[indexPath.row]
//            }
//        }
        
        AVAsset(url: URL(string: self.videoArray[indexPath.row])!).generateThumbnail {  (image) in
                        DispatchQueue.main.async {
                            guard let image = image else { return }
                            cell.videoImageView.image = image
                        }
                    }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Utility.isConnectedToInternet() {
            self.videoViewModel.playVideo(videoUrl: videoArray[indexPath.row], viewConroller: self)
        }else{
            self.showAlert(title: InternetConnectivity.noInternet, message: InternetConnectivity.internetMessage )
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
