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
    
    ///TEST DECOR FROM BINDLE
//    func localURL(for path: String) -> URL {
//        let cachesURL = folder.appendingPathComponent(fileName(from: path))
//
//        if FileManager.default.fileExists(atPath: cachesURL.path) {
//            return cachesURL
//        }
//
//        let name = path.replacingOccurrences(of: "/", with: "_")
//        let ext = (name as NSString).pathExtension
//        let resource = (name as NSString).deletingPathExtension
//
//        return Bundle.main.url(forResource: resource, withExtension: ext)!
//    }

    func exists(_ url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
}
