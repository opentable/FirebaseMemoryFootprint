//
//  NotificationService.swift
//  NotificationService
//
//  Created by Olivier Larivain on 8/7/17.
//  Copyright © 2017 Olivier Larivain. All rights reserved.
//

import UserNotifications

var didLink: Bool = false
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    let networkActivityQueue: DispatchQueue = DispatchQueue(label: "com.opentable.network.activity")

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        // look for the magic value "t" in the payload:
        // - if it's set to 1, we touch the firebase getter which causes configuration, and subsequent allocations
        // - if it's set to 2, we only touch TrackingService, not the FB getter, no allocations (== good!)
        if let t = request.content.userInfo["t"] as? Int {
            
            switch t {
            case 1:
                self.linkSharedFramework()
                if let serviceClazz = NSClassFromString("Shared.TrackingService") as? NSObject.Type {
                    let service = serviceClazz.init()
                    let fb = service.perform(NSSelectorFromString("firebase"))
                    NSLog("I have a Firebase here \(String(describing: fb))")
                }
            case 2:
                self.linkSharedFramework()
                if let serviceClazz = NSClassFromString("Shared.TrackingService") as? NSObject.Type {
                    let service = serviceClazz.init()
                    NSLog("I have a tracking service here \(service)")
                }
            default:
                NSLog("Just cruising, no nothing")
            }
        }
        
        if let bestAttemptContent = bestAttemptContent {
            self.networkActivityQueue.async {
                // sleeping for 5 seconds helps observing the process/capturing traces in instruments
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
    
    fileprivate func linkSharedFramework() {
        guard didLink == false else { return }
        didLink = true
        let url = Bundle.main.resourceURL?.deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Frameworks", isDirectory: true)
            .appendingPathComponent("Shared.framework", isDirectory: true)
            .appendingPathComponent("Shared", isDirectory: false)
            .absoluteString.replacingOccurrences(of: "file://", with: "")
        let handle = dlopen(url, RTLD_NOW)
        NSLog("Linking succeeded \(handle != nil)")
    }

}
