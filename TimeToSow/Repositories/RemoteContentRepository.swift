//
//  RemoteContentRepository.swift
//  TimeToSow
//
//  Created by Nebo on 24.01.2026.
//

import Foundation
import Supabase

protocol RemoteContentRepositoryProtocol {
    
}

class RemoteContentRepository: RemoteContentRepositoryProtocol {
    
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
    
    private func checkChallengesSeason() async {
        let currentSeason = await challengeRepository.getCurrentChallengeSeason()
        if currentSeason == nil {
            await updateChallengesSeason()
        } else if currentSeason?.version != version?.challengeVersion {
            await updateChallengesSeason()
        }
    }
    
    func updateChallengesSeason() async {
        do {
            let challengeUrl = try await client.storage
                .from("models")
                .createSignedURL(path: "challengeSeason.json", expiresIn: 60)
            
            let data = try Data(contentsOf: challengeUrl)
            data.printJSON()
            let challengeSeason = try JSONDecoder().decode(ChallengeSeasonRemote.self, from: data)
            print(challengeSeason)
            print(Date())
            await challengeRepository.addNewChallangeSeason(challengeSeason)
        } catch {
            fatalError()
        }
    }
    
    func fetchVersions() async throws -> ContentVersions {
        let signed = try await client.storage
            .from("models")
            .createSignedURL(path: "contentVersions.json", expiresIn: 60)
        
        let data = try Data(contentsOf: signed)
        data.printJSON()
        let version = try JSONDecoder().decode(ContentVersions.self, from: data)
        print(version)
        return version
    }
}

extension Data {
    func printJSON() {
        if let jsonString = String(data: self, encoding: .utf8) {
            print(jsonString)
        } else {
            print("❌ Не удалось преобразовать Data в строку")
        }
    }
}

struct ContentVersions: Codable {
    let challengeVersion: Int
}

struct ChallengeSeasonRemote: Codable {
    let version: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let challenges: [ChallengeModel]

}

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        version = try container.decode(Int.self, forKey: .version)
//        title = try container.decode(String.self, forKey: .title)
//        let startTs = try container.decode(Double.self, forKey: .startDate)
//        let endTs = try container.decode(Double.self, forKey: .endDate)
//        self.startDate = Date(timeIntervalSince1970: startTs)
//        self.endDate  = Date(timeIntervalSince1970: endTs)
//    }

//let client = SupabaseClient(
//    supabaseURL: URL(string: "https://wdjemgjqjoevvylteewd.supabase.co")!,
//    supabaseKey: "sb_publishable_7-Jo895jGaHwZuHOs1IYRw_nen0dCG8",
//    options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true) )
//)
//
//
//let signedURL = try? await client
//    .storage
//    .from("plant")
//    .createSignedURL(
//        path: "pot59.png",
//        expiresIn: 60 // секунды
//    )
//
//print(signedURL?.path())
//
//let signed = try! await client.storage
//    .from("models")
//    .createSignedURL(
//        path: "challengeList.json",
//        expiresIn: 60
//    )
//
//let data = try! Data(contentsOf: signed)
//let config = try! JSONDecoder().decode(Config.self, from: data)
//print(config)
//}
