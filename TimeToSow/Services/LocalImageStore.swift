//
//  LocalImageStore.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

final class LocalImageStore {
    static let shared = LocalImageStore()
    
    private let folder: URL = {
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("images")
    }()

    init() {
        try? FileManager.default.createDirectory(
            at: folder,
            withIntermediateDirectories: true
        )
    }

    func localURL(for path: String) -> URL {
        folder.appendingPathComponent(path.replacingOccurrences(of: "/", with: "_"))
    }

    func exists(_ url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
}
