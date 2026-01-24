//
//  Сhallenge.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation
import GRDB

struct ChallengeSeasonModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "challangeSeason"
    
    var id: UUID
    var version: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var challenges: [ChallengeModel]
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: ChallengeSeasonRemote) {
        self.id = UUID()
        self.version = from.version
        self.title = from.title
        self.startDate = from.startDate
        self.endDate = from.endDate
        self.challenges = from.challenges
    }
}

struct ChallengeSeason: Identifiable {
    let id: UUID
    let version: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let challenges: [Challenge]
    
    init(id: UUID, version: Int, title: String, startDate: Date, endDate: Date, challenges: [Challenge]) {
        self.id = id
        self.version = version
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.challenges = challenges
    }
    
    init(from: ChallengeSeasonModelGRDB) {
        self.id = from.id
        self.version = from.version
        self.title = from.title
        self.startDate = from.startDate
        self.endDate = from.endDate
        self.challenges = from.challenges.map { Challenge(from: $0) }
    }
    
//    init(from: ChallengeSeasonRemote) {
//        self.id = UUID()
//        self.version = from.version
//        self.title = from.title
//        self.startDate = from.startDate
//        self.endDate = from.endDate
//    }
}

struct Challenge: Identifiable {
    let id: UUID
    let title: String
    let type: ChallengeType
    let expectedValue: Int
    let expectedSecondValue: Int?
    let rewardDecor: Decor?
    let rewardRoom: RoomType?
    let rewardShelf: ShelfType?
    
    init(from: ChallengeModel) {
        id = UUID()
        title = from.title
        type = from.type
        expectedValue = from.expectedValue
        expectedSecondValue = from.expectedSecondValue
        
//        if let decor = from.rewardDecor {
//            rewardDecor = Decor(from: decor)
//        } else {
//            rewardDecor = nil
//        }
        
        rewardDecor = nil
        rewardRoom = nil
        rewardShelf = nil
    }
}

struct ChallengeModel: Codable {
    let title: String
    let type: ChallengeType
    let expectedValue: Int
    let expectedSecondValue: Int?
    let reward: DecorModel
}

struct DecorModel: Codable {
    let name: String
    let locationType: LocationType
    let animationOptions: AnimationOptions?
    let resourceUrl: String
    let height: CGFloat
}


//struct DecorModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
//    static let databaseTableName = "decor"
//    mutating func didInsert(with rowID: Int64, for column: String?) { }
//    
//    var id: UUID
//    var name: String
//    var locationType: LocationType
//    var animationOptions: AnimationOptions?
//    var resourceName: String
//    var positon: CGPoint
//    var height: CGFloat
//    var width: CGFloat
//    
//    init(from: Decor) {
//        id = from.id
//        name = from.name
//        locationType = from.locationType
//        animationOptions = from.animationOptions
//        resourceName = from.resourceName
//        positon = from.positon
//        height = from.height
//        width = from.width
//    }
//}

enum ChallengeType: String, Codable {
    case totalLoggetTime //общее залогированное время
    case numberOfPlants //количество растений
    case differentTagsUsed //количество использованных тэгов
    case numberOfPlantsNRarity //количество растений N редкости
    case daysInARow //количество логов дней под ряд
    case oneTimeRecordingTime //залогировать конкретное время N раз
    case newCategory // залогирвоать время с тэгом которого раньше не было
    case weekendProductivity // залогировать n раз в выходные дни
    case eveningProductivity // залогировать n раз в вечернее время
    case morningProductivity // залогировать n раз в утреннее время
    case consciousLogging // все логи имеют тэг отличный от "Другое"
    case minimumTimeNDay //количество дней с n часами
    case sharePlant //поделиться растением
    //можно было бы сделать челенджи по типам растений и горшков если их немного сигментировать (тать им тэги: цветок, большое, глиняный, модный, итд)
    
    func getDescription(expectedValue: Int, expectedSecondValue: Int?) -> String {
        return switch self {
        case .totalLoggetTime: "Общее время в этом месяце составляет более \(expectedValue) часов"
        case .numberOfPlants: "Вырастить минимум \(expectedValue) растений"
        case .differentTagsUsed: "Сделать минимум \(expectedValue) записи с разными тэгами"
        case .numberOfPlantsNRarity: "Количество растений с суммарная количество звезд равным \(expectedSecondValue ?? 0) не менее \(expectedValue)"
        case .daysInARow: "Для выполнения необходимо делать записи \(expectedValue) дней под ряд"
        case .oneTimeRecordingTime: "Необходимо выполнить минимум \(expectedValue) записей по \(expectedSecondValue ?? 0) минут"
        case .newCategory: ""
        case .weekendProductivity: "Для выполнения нужно сделать минимум \(expectedValue) записей в выходные дни (выходными днями считаются суббота и восскресение)"
        case .eveningProductivity: ""
        case .morningProductivity: ""
        case .consciousLogging: ""
        case .minimumTimeNDay: ""
        case .sharePlant: ""
        }
    }
}
