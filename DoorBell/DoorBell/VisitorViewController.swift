//
//  VisitorViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VisitorViewController: UIViewController {
  @IBOutlet weak var visitorView: UIWebView!
  @IBOutlet weak var currentTime: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    visitorView.scalesPageToFit = true
    visitorView.contentMode = .scaleAspectFit
    visitorView.loadRequest(URLRequest(url: URL(string: "http://60.205.206.174:3000/getFile")!))
    let now = Date()
    let dformatter = DateFormatter()
    dformatter.dateFormat = "HH:mm"
    currentTime.text = String(describing: dformatter.string(from: now))
    
    Alamofire.request("http://60.205.206.174:3000/getData", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
      if let responseData = response.result.value {
        let responseJson = JSON(data: responseData.data(using: String.Encoding.utf8)!)
        
        let similarity  = UILabel(frame: CGRect(x: 204, y: 392, width: 100, height: 21))
        similarity.text = responseJson["confidence"].stringValue
        similarity.textColor = UIColor.darkGray
        self.view.addSubview(similarity)
        
        if let similarityData: Double = Double(responseJson["confidence"].stringValue) {
          if similarityData < 0.7 {
            let alertController = UIAlertController(title: "Hola", message: "Having a new Stranger!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
          }
        } else {
          print("Oops! Could not get confidence data.")
        }
      } else {
        print("Oops! There has some problems in network.")
      }
    }
  }
  
  func addAlert() {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
}
