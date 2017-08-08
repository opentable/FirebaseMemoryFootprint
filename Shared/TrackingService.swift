//
//  TrackingService.swift
//  OpenTable
//
//  Created by Olivier Larivain on 8/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

public final class TrackingService: NSObject {
	
	public static var sharedInstance: TrackingService = TrackingService()

    fileprivate(set) public lazy var firebase: Firebase = { Firebase() }()
    
}
