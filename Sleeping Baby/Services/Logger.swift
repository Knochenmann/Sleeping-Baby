//
//  Logger.swift
//  Sleeping Baby
//

import Foundation

final class Logger {
    
    // MARK: Static Properties
    
    static let shared = Logger()
    
    // MARK: Life Cycle
    
    private init() { }
    
    // MARK: Public Functions
    
    func log(_ error: NSError) {
        print("Unresolved error:\n\(error.description)")
    }
    
}
