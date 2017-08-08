//
//  NotificationService.swift
//  NotificationService
//
//  Created by Olivier Larivain on 8/7/17.
//  Copyright © 2017 Olivier Larivain. All rights reserved.
//

import UserNotifications

// if you want to do a control/test type of thing, then ucomment the following line,
// also comment references to TrackingService below,
// and don't forget to unlink "Shared" from the project settings 
import Shared

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    let networkActivityQueue: DispatchQueue = DispatchQueue(label: "com.opentable.network.activity")

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let _ = TrackingService.sharedInstance
        let _ = TrackingService.sharedInstance.firebase

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            self.networkActivityQueue.async {
                // we're doing a sleep for 5 seconds here, for one thing it simulates real life use cases where a network call
                // is being triggered, and it also helps to keep the process alive for longer for observation purposes.
                sleep(5)
                
                
                bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
                
                contentHandler(bestAttemptContent)
            }
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
