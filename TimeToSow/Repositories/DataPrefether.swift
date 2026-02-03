//
//  DataPrefether.swift
//  TimeToSow
//
//  Created by Nebo on 04.02.2026.
//

import Foundation
import Supabase

protocol PrefetcherImageProtocol {
    func prefetchImages(imagePaths: [String]) async
    func imageURL(for path: String) async -> URL?
}

final class DataPrefether: PrefetcherImageProtocol {
    
    private var client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    //MARK: PrefetcherImageProtocol
    func imageURL(for path: String) async -> URL? {
        let localStore = LocalImageStore.shared
        let localURL = localStore.localURL(for: path)
        
        if localStore.exists(localURL) {
            return localURL
        }
        
        do {
            let signed = try await client.storage
                .from("")
                .createSignedURL(path: path, expiresIn: 60)
            let (data, _) = try await URLSession.shared.data(from: signed)
            try data.write(to: localURL, options: .atomic)
            Logger.log("image \(path) success saved", location: .imageFetcher, event: .success)
            return localURL
        } catch {
            Logger.log("image \(path) not saved", location: .imageFetcher, event: .error(error))
            return nil
        }
    }
    
    func prefetchImages(imagePaths: [String]) async {
        await withTaskGroup(of: Void.self) { group in
            for path in imagePaths {
                group.addTask {
                    _ = await self.imageURL(for: path)
                }
            }
        }
        Logger.log("Finish prefetcher load \(imagePaths.count) images", location: .imageFetcher, event: .success)
    }
}
