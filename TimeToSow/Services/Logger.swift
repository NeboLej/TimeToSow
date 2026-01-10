//
//  Logger.swift
//  TimeToSow
//
//  Created by Nebo on 10.01.2026.
//

import Foundation

final class Logger {
    
    enum Location {
        case GRDB
        case unowned
        
        var text: String {
            switch self {
            case .GRDB: return "💿"
            case .unowned: return "🧭"
            }
        }
    }
    
    enum Status {
        case success
        case error(Error? = nil)
        case unowned
        
        var text: String {
            switch self {
            case .success: return "☘️"
            case let .error(error): return "🆘 ERROR: \(error?.localizedDescription ?? "N/A")"
            case .unowned: return "👾"
            }
        }
    }
    
    private init() {}
    
    static func log(_ text: String = "", location: Location = .unowned, event: Status = .unowned) {
        print(["LOG: ", location.text, event.text, " ---- ",  text].joined())
    }
}

