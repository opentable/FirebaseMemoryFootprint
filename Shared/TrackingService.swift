//
//  TrackingService.swift
//  OpenTable
//
//  Created by Olivier Larivain on 8/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

public final class TrackingService: NSObject {

    // you'll notice that this is lazy loaded, but since firebase is statically linked into Shared, the mere fact
    // of loading Shared causes Firebase to kick in and eat up a lot of ram
    fileprivate(set) public lazy var firebase: Firebase = { Firebase() }()
    
}
