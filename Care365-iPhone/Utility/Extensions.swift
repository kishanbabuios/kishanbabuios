//
//  Extensions.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import Foundation
import UIKit
import AVKit
import SCLAlertView
extension UIViewController{
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func presentFromPushViewController(storyBoard: UIStoryboard, viewContoller : UIViewController, vcIdentifier:String)  {
        guard  let viewC = storyBoard.instantiateViewController(identifier: vcIdentifier) as? UIViewController else {return}
        let nc = UINavigationController(rootViewController: viewC)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true, completion: nil)
    }
    func showIndicator(){
            ViewControllerUtils.shared.showActivityIndicator(uiView: self.view)
        
    }
    
    func hideIndicator()  {
        DispatchQueue.main.async {
            ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
        }
    }
    func postDateAndTime() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        //2021-05-05T15:15:56.306Z
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
  return myStringafd
    }
    func responseDateFormatter(dateString :  String) -> String {
        let dateParser = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+05:30"
        dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm"
        guard let datetime = dateParser.date(from: dateString) else { return "" }
        PrintLog.print(dateFormatter1.string(from: datetime))
        return dateFormatter1.string(from: datetime)
    }
    
    func nextWeightCheckUp(interval : Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let calendar = NSCalendar.current
        let newDate = calendar.date(byAdding: .hour, value: interval, to: Date())
        PrintLog.print(Date() , dateFormatter.string(from: newDate!))
        let updatedDate = dateFormatter.string(from: newDate!)
        let ad = updatedDate.components(separatedBy: " ")
              return ad[0]
    }
}
extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

