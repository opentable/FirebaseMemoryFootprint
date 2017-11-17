//
//  Firebase.swift
//  OpenTable
//
//  Created by Olivier Larivain on 12/9/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics


public class Firebase: NSObject {
    
    override public required init() {
        let options = FirebaseOptions(googleAppID: "1:157617603567:ios:461ea6ad218e734c",
                                      gcmSenderID: "157617603567")
        if let bundle = Bundle.main.bundleIdentifier {
            options.bundleID = bundle
        }
        options.apiKey =  "AIzaSyC8W5oACklZ4_gCKCTa2NFLOLAci1qtY1U"
        options.clientID = "157617603567-im59h0jq2l0f833eqb6pltac16scmku3.apps.googleusercontent.com"
        options.databaseURL = "https://opentable-consumer.firebaseio.com"
        options.storageBucket = "opentable-consumer.appspot.com"
        FirebaseApp.configure(options: options)
	}

	public func track(_ event: String, properties: [String : Any]? = nil) {
        Analytics.logEvent(event, parameters: properties as? [String : NSObject])
	}
	
	public func handleURL(_ url: URL?) {
        guard let url = url else { return }
        Analytics.handleOpen(url)
	}
	
	public func handleUserActivity(_ activity: NSUserActivity?) {
        guard let activity = activity else { return }
        Analytics.handleUserActivity(activity)
	}
    

}
