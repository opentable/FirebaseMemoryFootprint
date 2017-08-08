//
//  ViewController.swift
//  FirebaseNotificationFootprint
//
//  Created by Olivier Larivain on 8/7/17.
//  Copyright © 2017 Olivier Larivain. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func register(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            let alert = UIAlertController(title: "Registration",
                                          message: "Registration was \(success ? "successful" : "unsuccessful")",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.registerForRemoteNotifications()
            })
            self.present(alert, animated: true)
        }
    }
}
