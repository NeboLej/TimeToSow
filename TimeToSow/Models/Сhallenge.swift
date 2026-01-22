//
//  Сhallenge.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

struct Challenge: Identifiable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let type: ChallengeType
    let expectedValue: Int
    let expectedSecondValue: Int?
    let rewardDecor: Decor?
    let rewardRoom: RoomType?
    let rewardShelf: ShelfType?
}

enum ChallengeType {
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
        "челленджи на период хорошо усиливают вовлечённость 👍 а особенно этот"
    }
}

struct ChallengeSeason: Identifiable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let challenges: [Challenge]
}
