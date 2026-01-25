//
//  Data + extension.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

extension Data {
    func printJSON() {
        if let jsonString = String(data: self, encoding: .utf8) {
            print(jsonString)
        } else {
            Logger.log("Не удалось преобраховать data в json ", location: .unowned, event: .error(nil))
        }
    }
}
