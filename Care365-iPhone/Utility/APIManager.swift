//
//  APIManager.swift
//  Care365-iPhone
//
//  Created by Apple on 29/03/21.
//

import Foundation
import Alamofire
class APIManager {
    static let instance = APIManager()
    // Good to use private keyword to prevent other objects from creating their own instances
    private init() {}
    func postDataToServerWithoutHeadersMethod(url:String,parameters:[String:AnyObject],success:@escaping(Any,Int)->(),failure:@escaping(String)->()) {
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        success(data, response.statusCode)
                    } catch {
                        failure(error.localizedDescription)
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    func postDataToServerHeadersMethod(url:String,parameters:[String:AnyObject],success:@escaping(Any,Int)->(),failure:@escaping(String)->()) {
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        success(data, response.statusCode)
                    } catch {
                        failure(error.localizedDescription)
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    func getUrlSessionHeaderDetailsFromServerMethod(url:String,success:@escaping(Any,Int)->(),failure:@escaping(String)->()){
        
        
        let url = URL(string: url)
        guard let requestUrl = url else { fatalError() }

        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                failure(error.localizedDescription)
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                // Convert HTTP Response Data to a simple String
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        success(data, response.statusCode)
                    } catch {
                        failure(error.localizedDescription)
                    }
                }

            }
            
            
        }
        task.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
//        let url = URL(string: url)! //change the url
//           //create the session object
//           let session = URLSession.shared
//           //now create the URLRequest object using the url object
//           //let request = URLRequest(url: url)
//           var request = URLRequest(url: url)
//           request.httpMethod = "GET"
//           request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//           request.allHTTPHeaderFields = headers
//           //create dataTask using the session object to send data to the server
//           let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//               guard error == nil else {
//                   return
//               }
//               guard let data = data else {
//                   return
//               }
//              do {
//                 //create json object from data
//                print(data.base64EncodedString())
//                 if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    print(json)
//                    success(json)
//                 }
//              } catch let error {
//                failure(error.localizedDescription)
//                print(error.localizedDescription)
//              }
//           })
//
//           task.resume()
    }
}
