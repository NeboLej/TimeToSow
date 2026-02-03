//
//  RemoteContentRepository.swift
//  TimeToSow
//
//  Created by Nebo on 24.01.2026.
//

import Foundation
import Supabase

protocol BackgroundEventDeleagate: AnyObject {
    func send(_ action: BackgroundEventAction)
}

protocol RemoteContentRepositoryProtocol {
    func updateRemoteData()
    func setDelegate(_ delegate: BackgroundEventDeleagate)
}

final class RemoteContentRepository: RemoteContentRepositoryProtocol {
    
    private let challengeRepository: ChallengeRepositoryProtocol
    private var version: ContentVersions?
    private weak var delegate: BackgroundEventDeleagate?
    
    private let client: SupabaseClient
    private let imagePrefetcher: PrefetcherImageProtocol
    
    init(client: SupabaseClient, challengeRepository: ChallengeRepositoryProtocol, imagePrefetcher: PrefetcherImageProtocol) {
        self.challengeRepository = challengeRepository
        self.client = client
        self.imagePrefetcher = imagePrefetcher
        
        updateRemoteData()
        loadLocalJSONLocalization()
    }
    
    private func loadLocalJSONLocalization() {
        guard let url = Bundle.main.url(forResource: "remote_localization", withExtension: "json") else {
            assertionFailure("Localization JSON not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            try JSONLocalizationService.shared.load(from: data)
            Logger.log("Succes fetch localized srings", location: .remote, event: .success)
        } catch {
            assertionFailure("Failed to load localization: \(error)")
        }
    }
    
    //MARK: RemoteContentRepositoryProtocol
    func updateRemoteData() {
        Task {
            do {
                version = try await fetch(path: "contentVersions.json", type: ContentVersions.self)
                Logger.log("Succes fetch version content", location: .remote, event: .success)
                await checkChallengesSeason()
            } catch {
                Logger.log("Error fetch versioin content", location: .remote, event: .error(error))
            }
        }
    }
    
    func setDelegate(_ delegate: BackgroundEventDeleagate) {
        self.delegate = delegate
    }
    
    //MARK: private
    private func checkChallengesSeason() async {
        let currentSeason = await challengeRepository.getCurrentChallengeSeason()
        if currentSeason == nil || currentSeason?.version != version?.challengeVersion {
            await updateChallengesSeason()
        } else {
            delegate?.send(.challengesSeasonPrepared(currentSeason!))
        }
    }
    
    private func updateChallengesSeason() async {
        do {
            let challengeSeason = try await fetch(path: "challengeSeason.json", type: ChallengeSeasonRemote.self)
            await imagePrefetcher.prefetchImages(imagePaths: challengeSeason.challenges.map { $0.reward.resourceUrl })
            await challengeRepository.addNewChallangeSeason(challengeSeason)
            
            if let currentSeason = await challengeRepository.getCurrentChallengeSeason() {
                delegate?.send(.challengesSeasonPrepared(currentSeason))
            }
            Logger.log("Succes fetch challange season", location: .remote, event: .success)
        } catch {
            fatalError()
        }
    }
    
    private func fetch<T: Decodable>(path: String, type: T.Type) async throws -> T {
        let url = try await client.storage
            .from("models")
            .createSignedURL(path: path, expiresIn: 60)
        
        let data = try Data(contentsOf: url)
        data.printJSON()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(type.self, from: data)
        return response
    }
}

struct ContentVersions: Codable {
    let challengeVersion: Int
}
