//
//  JSONLocalizationService.swift
//  TimeToSow
//
//  Created by Nebo on 29.12.2025.
//

import Foundation

typealias LanguageCode = String
typealias LocalizationKey = String

class RemoteText {
    static func text(_ key: String) -> String {
        JSONLocalizationService.shared.string(for: key) ?? key
    }
}

fileprivate struct JSONLocalization: Decodable {
    let data: [LanguageCode: [LocalizationKey: String]]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.data = try container.decode([LanguageCode: [LocalizationKey: String]].self)
    }
}

final class JSONLocalizationService {

    static let shared = JSONLocalizationService()

    private var storage: [String: String] = [:]
    
    private init() {
        LocalizedFilesType.allCases.forEach { type in
            let url = fileURL(for: type)
            if let data = try? Data(contentsOf: url) {
                try? load(from: data, type: type)
            }
        }
    }
    
    private func fileURL(for type: LocalizedFilesType) -> URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask ).first!

        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        return dir.appendingPathComponent(type.fileName)
    }

    func load(from data: Data, locale: Locale = .current, type: LocalizedFilesType) throws {
        try? data.write(to: fileURL(for: type), options: .atomic)
        
        let decoded = try JSONDecoder().decode(JSONLocalization.self, from: data)

        let languageCode = locale.language.languageCode?.identifier ?? "en"
        let decodedData = decoded.data[languageCode] ?? [:]
        storage.merge(decodedData) { _, new in new }
    }

    func string(for key: String) -> String? {
        return storage[key]
    }
    
    func getSavedVersions() -> [LocalizedFilesType: Int] {
        var result = [LocalizedFilesType: Int]()
        
        LocalizedFilesType.allCases.forEach {
            let key = "savedLocalizationVersion.\($0.rawValue)"
            let version = UserDefaults.standard.integer(forKey: key)
            result[$0] = version
        }
        
        return result
    }
    
    func saveNewVerion(type: LocalizedFilesType, version: Int) {
        let key = "savedLocalizationVersion.\(type.rawValue)"
        UserDefaults.standard.set(version, forKey: key)
    }
}

enum LocalizedFilesType: String, CaseIterable {
    case challenge, other
    
    var fileName: String {
        switch self {
        case .challenge: "localizedChallenge.json"
        case .other: "other.json"
        }
    }
}
