//
//  ChallengeType.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

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
