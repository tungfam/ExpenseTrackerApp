//
//  OBRequestWrapper.swift
//  OBSLY
//
//  Created by Tung Fam on 9/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBRequestWrapper: NSObject {

    let backendPath = "http://obsly.com/api/v1/"
    static let sharedInstance = OBRequestWrapper()
    
    func getCurrenciesWithCompletionBlock(completion: @escaping (_ responseObject: Any) -> Void)  {
        let defaults = UserDefaults.standard
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let urlPath: String = "\(self.backendPath)\(chosenBookKey)/currencies"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            print("Data: \(data)")
            print("Error: \(error)")
            if(error != nil) {
                print("Server Error: \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    print("Networking error while getting currencies: \(error)")
                }
            }
            else    {
                do {
                    // handle error
                    let jsonDictResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print(jsonDictResponse ?? "jsonDictResponse is empty")
                    if (jsonDictResponse?["error"]) != nil  { // if data contains error
                        DispatchQueue.main.async {
                            print("Networking error while getting currencies: \(jsonDictResponse?["error"])")
                        }
                    } // handle error
                    
                    let jsonArrayResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    print(jsonArrayResponse ?? "jsonDictResponse is empty")
                    completion(jsonArrayResponse)
//                    currenciesArray = jsonArrayResponse as! Array<Dictionary<String, AnyObject>>
//                    DispatchQueue.main.async{
//                        self.chooseLabelsTableView.reloadData()
//                        
//                        //                        blurView.removeFromSuperview()
//                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
}
