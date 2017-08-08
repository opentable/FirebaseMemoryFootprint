//
//  NotificationService.swift
//  NotificationService
//
//  Created by Olivier Larivain on 8/7/17.
//  Copyright © 2017 Olivier Larivain. All rights reserved.
//

import UserNotifications
import Shared

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    let networkActivityQueue: DispatchQueue = DispatchQueue(label: "com.opentable.network.activity")

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        TrackingService.sharedInstance.firebase.dummyField = false

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            self.networkActivityQueue.async {
                sleep(5)
                // Modify the notification content here...
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
