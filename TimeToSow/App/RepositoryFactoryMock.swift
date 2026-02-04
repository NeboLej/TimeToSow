//
//  RepositoryFactoryMock.swift
//  TimeToSow
//
//  Created by Nebo on 04.02.2026.
//

import Foundation
import GRDB

class RepositoryFactoryMock: RepositoryFactoryProtocol {
    
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
    let taskService: TaskServiceProtocol
    
    init() {
        let dbPool: DatabasePool = DatabaseManager.shared.dbPool
        
//        let client = SupabaseClient(supabaseURL: URL(string: Secrets.superBaseUrl)!,
//                                    supabaseKey: Secrets.superBaseKey,
//                                    options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true)))
        let dataPrefetcher = ImageDownloaderMock()
        
        tagRepository = TagRepository(dbPool: dbPool)
        shelfRepository = ShelfRepository(dbPool: dbPool)
        roomRepository = RoomRepository(dbPool: dbPool)
        seedRepository = SeedRepository(dbPool: dbPool)
        potRepository = PotRepository(dbPool: dbPool)
        challengeRepository = ChallengeRepository(dbPool: dbPool)
        plantRepository = PlantRepository(dbPool: dbPool, seedRepository: seedRepository, potRepository: potRepository)
        decorRepository = DecorRepository(dbPool: dbPool)
        myRoomRepository = UserRoomRepository(dbPool: dbPool, imagePrefetcher: dataPrefetcher)
        remoteRepository = RemoteRepositoryMock()
        
        challengeService = ChallengeService(challengeRepository: challengeRepository)
        
        let taskRepository: TaskRepositoryProtocol = TaskRepository(dbPool: dbPool)
        let localNotificationService: LocalNotificationServiceProtocol = LocalNotificationService()
        
        taskService = TaskService(repository: taskRepository, localNotificationService: localNotificationService)
    }
}

class RemoteRepositoryMock: RemoteContentRepositoryProtocol {
    func updateRemoteData() {
        
    }
    
    func setDelegate(_ delegate: any BackgroundEventDeleagate) {
        
    }
}

class ImageDownloaderMock: PrefetcherImageProtocol {
    func prefetchImages(imagePaths: [String]) async {
        
    }
    
    func imageURL(for path: String) async -> URL? {
        nil
    }
}
