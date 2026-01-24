//
//  RemoteContentRepository.swift
//  TimeToSow
//
//  Created by Nebo on 24.01.2026.
//

import Foundation
import Supabase

protocol RemoteContentRepositoryProtocol: ImageRepositoryProtocol {
    func updateRemoteData()
}

protocol ImageRepositoryProtocol {
    func imageURL(for path: String) async -> URL?
}

final class RemoteContentRepository: RemoteContentRepositoryProtocol {
    
    private let challengeRepository: ChallengeRepositoryProtocol
    private var version: ContentVersions?
    
    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://wdjemgjqjoevvylteewd.supabase.co")!,
        supabaseKey: "",
        options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true) )
    )
    
    init(challengeRepository: ChallengeRepositoryProtocol) {
        self.challengeRepository = challengeRepository
        
        updateRemoteData()
    }
    
    //MARK: RemoteContentRepositoryProtocol
    
    func updateRemoteData() {
        Task {
            do {
                version = try await fetchVersions()
                await checkChallengesSeason()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: ImageRepositoryProtocol
    
    func imageURL(for path: String) async -> URL? {
        let localStore = LocalImageStore.shared
        let localURL = localStore.localURL(for: path)

        if localStore.exists(localURL) {
            return localURL
        }

        do {
            let signed = try await client
                .storage
                .from("")
                .createSignedURL(path: path, expiresIn: 60)
            
            let (data, _) = try await URLSession.shared.data(from: signed)
            try data.write(to: localURL, options: .atomic)
            return localURL
        } catch {
            return nil
        }
    }
    
    //MARK: private
    
    private func checkChallengesSeason() async {
        let currentSeason = await challengeRepository.getCurrentChallengeSeason()
        if currentSeason == nil {
            await updateChallengesSeason()
        } else if currentSeason?.version != version?.challengeVersion {
            await updateChallengesSeason()
        }
    }
    
    private func updateChallengesSeason() async {
        do {
            let challengeUrl = try await client.storage
                .from("models")
                .createSignedURL(path: "challengeSeason.json", expiresIn: 60)
            
            let data = try Data(contentsOf: challengeUrl)
            data.printJSON()
            let challengeSeason = try JSONDecoder().decode(ChallengeSeasonRemote.self, from: data)
            await prefetchImages(imagePaths: challengeSeason.challenges.map { $0.reward.resourceUrl })
            await challengeRepository.addNewChallangeSeason(challengeSeason)
        } catch {
            fatalError()
        }
    }
    
    private func fetchVersions() async throws -> ContentVersions {
        let signed = try await client.storage
            .from("models")
            .createSignedURL(path: "contentVersions.json", expiresIn: 60)
        
        let data = try Data(contentsOf: signed)
        data.printJSON()
        let version = try JSONDecoder().decode(ContentVersions.self, from: data)
        print(version)
        return version
    }
    
    private func prefetchImages(imagePaths: [String]) async {
        await withTaskGroup(of: Void.self) { group in
            for path in imagePaths {
                group.addTask {
                    _ = await self.imageURL(for: path)
                }
            }
        }
    }
}

struct ContentVersions: Codable {
    let challengeVersion: Int
}

