//
//  RepositoryFactory.swift
//  TimeToSow
//
//  Created by Nebo on 04.02.2026.
//

import Foundation
import GRDB
import Supabase

protocol RepositoryFactoryProtocol {
    var tagRepository: TagRepositoryProtocol { get }
    var shelfRepository: ShelfRepositoryProtocol { get }
    var roomRepository: RoomRepositoryProtocol { get }
    var seedRepository: SeedRepositoryProtocol { get }
    var potRepository: PotRepositoryProtocol { get }
    var myRoomRepository: UserRoomRepositoryProtocol { get }
    var challengeRepository: ChallengeRepositoryProtocol { get }
    var decorRepository: DecorRepositoryProtocol { get }
    var plantRepository: PlantRepositoryProtocol { get }
    var challengeService: ChallengeServiceProtocol { get }
    var remoteRepository: RemoteContentRepositoryProtocol { get }
}

class RepositoryFactoryMock {
    
}

class RepositoryFactory: RepositoryFactoryProtocol {
    let tagRepository: TagRepositoryProtocol
    let shelfRepository: ShelfRepositoryProtocol
    let roomRepository: RoomRepositoryProtocol
    let seedRepository: SeedRepositoryProtocol
    let potRepository: PotRepositoryProtocol
    let myRoomRepository: UserRoomRepositoryProtocol
    let challengeRepository: ChallengeRepositoryProtocol
    let decorRepository: DecorRepositoryProtocol
    let plantRepository: PlantRepositoryProtocol
    let challengeService: ChallengeServiceProtocol
    let remoteRepository: RemoteContentRepositoryProtocol
    
    
    init() {
        let dbPool: DatabasePool = DatabaseManager.shared.dbPool
        let client = SupabaseClient(supabaseURL: URL(string: "https://wdjemgjqjoevvylteewd.supabase.co")!,
                                                    supabaseKey: "sb_publishable_7-Jo895jGaHwZuHOs1IYRw_nen0dCG8",
                                                    options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true)))
        let dataPrefetcher = DataPrefether(client: client)
        
        tagRepository = TagRepository(dbPool: dbPool)
        shelfRepository = ShelfRepository(dbPool: dbPool)
        roomRepository = RoomRepository(dbPool: dbPool)
        seedRepository = SeedRepository(dbPool: dbPool)
        potRepository = PotRepository(dbPool: dbPool)
        challengeRepository = ChallengeRepository(dbPool: dbPool)
        plantRepository = PlantRepository(dbPool: dbPool, seedRepository: seedRepository, potRepository: potRepository)
        decorRepository = DecorRepository(dbPool: DatabaseManager.shared.dbPool)
        myRoomRepository = UserRoomRepository(dbPool: dbPool, imagePrefetcher: dataPrefetcher)
        remoteRepository = RemoteContentRepository(client: client, challengeRepository: challengeRepository, imagePrefetcher: dataPrefetcher)
        
        challengeService = ChallengeService(challengeRepository: challengeRepository)
    }
}
