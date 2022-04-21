//
//  FileManager+Extentions.swift
//  Activity Tracker
//
//  Created by luu van on 4/21/22.
//

import UIKit

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
