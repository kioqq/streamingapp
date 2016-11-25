//
//  SAInterfaceManager.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/25/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation
import UIKit

class SAInterfaceManager {

    var rootNavigation = SANavigationControler(rootVC: SAMainViewController())
    
    //
    // Shared instance
    //
    
    fileprivate static let shared = SAInterfaceManager()
    
    static func sharedManager() -> SAInterfaceManager {
        return shared
    }

}
