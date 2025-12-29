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

    private init() {}

    func load(from data: Data, locale: Locale = .current) throws {
        let decoded = try JSONDecoder().decode(JSONLocalization.self, from: data)

        let languageCode = locale.language.languageCode?.identifier ?? "en"
        storage = decoded.data[languageCode] ?? [:]
    }

    func string(for key: String) -> String? {
        return storage[key]
    }
}
