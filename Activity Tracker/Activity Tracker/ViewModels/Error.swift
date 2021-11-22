//
//  Error.swift
//  Activity Tracker
//
//  Created by luu van on 11/15/21.
//

import Foundation

enum DataError: Error {
    case dataValidationFailed(String)
    case coreDataError(Error)
    
    var message: String {
        switch self {
        case .dataValidationFailed(let msg): return msg
        case .coreDataError(let error): return error.localizedDescription
        }
    }
}
