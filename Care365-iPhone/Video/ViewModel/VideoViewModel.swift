//
//  VideoViewModel.swift
//  Care365-iPhone
//
//  Created by Apple on 01/04/21.
//

import Foundation
import UIKit
import AVKit

class  VideoViewModel{
    func playVideo(videoUrl : String, viewConroller : UIViewController)  {
        let videoURL = URL(string: videoUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
                viewConroller.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
