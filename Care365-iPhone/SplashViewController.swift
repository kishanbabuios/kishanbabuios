//
//  SplashViewController.swift
//  Care365-iPhone
//
//  Created by Apple on 02/04/21.
//

import UIKit
import SideMenuSwift
class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        guard let vc = StoryBoards.mainStoryBoard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if isLoggedIn == false {
//            guard let vc = StoryBoards.mainStoryBoard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
//                return
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            let contentViewController = StoryBoards.homeStoryBoard.instantiateViewController(withIdentifier: "menuNavigationController")
//            let menuViewController = StoryBoards.homeStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//            let sidemenu = SideMenuController(contentViewController: contentViewController,menuViewController: menuViewController)
//            SideMenuController.preferences.basic.menuWidth = self.view.frame.width - 60
//            SideMenuController.preferences.basic.position = .above
//            SideMenuController.preferences.basic.direction = .left
//            SideMenuController.preferences.basic.enablePanGesture = true
//            SideMenuController.preferences.basic.supportedOrientations = .portrait
//            SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
//            self.navigationController?.pushViewController(sidemenu, animated: true)
//        }
        }
        
    }


