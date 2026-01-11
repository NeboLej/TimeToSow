//
//  DefaultValue.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation

struct DefaultModels {
    
    //MARK: - TAGS
    static let tags: [Tag] = [
        Tag(stableId: "default_1", name: "Job", color: "#EE05F2"),
        Tag(stableId: "default_2", name: "Yoga", color: "#68F205"),
        Tag(stableId: "default_3", name: "Programm", color: "#F2E205"),
        Tag(stableId: "default_4", name: "Read", color: "#F25C05"),
        Tag(stableId: "default_5", name: "Run in the morning", color: "#8C8303")
    ]
    
    //MARK: - ROOMS
    static let rooms: [RoomType] = [
        RoomType(name: "1", image: "room1"),
        RoomType(name: "3", image: "room7"),
        RoomType(name: "3", image: "room8"),
        RoomType(name: "3", image: "room9"),
        RoomType(name: "3", image: "room10"),
        RoomType(name: "3", image: "room11"),
        RoomType(name: "3", image: "room12"),
    ]
    
    //MARK: - SHELFS
    static let shelfs: [ShelfType] = [
        ShelfType(name: "1", image: "shelf1", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
        ]),
        
        ShelfType(name: "2", image: "shelf2", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
        ]),
        
        ShelfType(name: "3", image: "shelf3", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.682, paddingLeading: 30, paddingTrailing: 266),
            ShelfPosition(coefOffsetY: 0.468, paddingLeading: 190, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.46, paddingLeading: 20, paddingTrailing: 260),
            ShelfPosition(coefOffsetY: 0.256, paddingLeading: 39, paddingTrailing: 170),
            ShelfPosition(coefOffsetY: 0.254, paddingLeading: 280, paddingTrailing: 19),
        ]),
        
        ShelfType(name: "3", image: "shelf4", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.253, paddingLeading: 19, paddingTrailing: 228),
            ShelfPosition(coefOffsetY: 0.389, paddingLeading: 232, paddingTrailing: 15),
            ShelfPosition(coefOffsetY: 0.538, paddingLeading: 19, paddingTrailing: 206),
            ShelfPosition(coefOffsetY: 0.656, paddingLeading: 236, paddingTrailing: 10),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5)
        ]),
        
        ShelfType(name: "3", image: "shelf5", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.137, paddingLeading: 215, paddingTrailing: 115),
            ShelfPosition(coefOffsetY: 0.263, paddingLeading: 140, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.402, paddingLeading: 85, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.407, paddingLeading: 13, paddingTrailing: 333),
            ShelfPosition(coefOffsetY: 0.559, paddingLeading: 85, paddingTrailing: 115),
            ShelfPosition(coefOffsetY: 0.681, paddingLeading: 308, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.693, paddingLeading: 13, paddingTrailing: 333),
            ShelfPosition(coefOffsetY: 0.827, paddingLeading: 308, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5)
        ]),
        
        ShelfType(name: "3", image: "shelf6", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.208, paddingLeading: 28, paddingTrailing: 35),
            ShelfPosition(coefOffsetY: 0.43, paddingLeading: 212, paddingTrailing: 40),
            ShelfPosition(coefOffsetY: 0.525, paddingLeading: 36, paddingTrailing: 236),
            ShelfPosition(coefOffsetY: 0.606, paddingLeading: 195, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.935, paddingLeading: 5, paddingTrailing: 5),
        ]),
        
        ShelfType(name: "3", image: "shelf7", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.206, paddingLeading: 200, paddingTrailing: 20),
            ShelfPosition(coefOffsetY: 0.363, paddingLeading: 245, paddingTrailing: 30),
            ShelfPosition(coefOffsetY: 0.544, paddingLeading: 24, paddingTrailing: 150),
            ShelfPosition(coefOffsetY: 0.94, paddingLeading: 5, paddingTrailing: 5)
        ]),
        
        ShelfType(name: "3", image: "shelf8", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.206, paddingLeading: 16, paddingTrailing: 110),
            ShelfPosition(coefOffsetY: 0.418, paddingLeading: 114, paddingTrailing: 12),
            ShelfPosition(coefOffsetY: 0.668, paddingLeading: 30, paddingTrailing: 283),
            ShelfPosition(coefOffsetY: 0.77, paddingLeading: 230, paddingTrailing: 20),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
        ]),
        
        ShelfType(name: "3", image: "shelf9", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.22, paddingLeading: 29, paddingTrailing: 232),
            ShelfPosition(coefOffsetY: 0.22, paddingLeading: 224, paddingTrailing: 34),
            ShelfPosition(coefOffsetY: 0.453, paddingLeading: 34, paddingTrailing: 29),
            ShelfPosition(coefOffsetY: 0.717, paddingLeading: 70, paddingTrailing: 232),
            ShelfPosition(coefOffsetY: 0.717, paddingLeading: 224, paddingTrailing: 84),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
        ])
    ]
    //MARK: - POTS
    static let pots: [Pot] = [
        Pot(name: "pot1.name", image: "pot1", height: 20, rarity: .common),
        Pot(name: "pot2.name", image: "pot2", height: 25, rarity: .common),
        Pot(name: "pot3.name", image: "pot3", height: 20, rarity: .common),
        Pot(name: "pot5.name", image: "pot5", height: 22,rarity: .rare),
        Pot(name: "pot6.name", image: "pot6", height: 25, rarity: .rare),
        Pot(name: "pot7.name", image: "pot7",height: 25,rarity: .rare),
        Pot(name: "pot8.name", image: "pot8", height: 25, rarity: .rare),
        Pot(name: "pot9.name", image: "pot9", height: 25, rarity: .rare),
        Pot(potFeatures: [.narrow], name: "pot10.name", image: "pot10", height: 18, rarity: .epic),
        Pot(name: "pot11.name", image: "pot11", height: 35, rarity: .legendary, anchorPointCoefficient: .init(x: 0, y: 0.23)),
        Pot(name: "pot12.name", image: "pot12", height: 30, rarity: .epic),
        Pot(name: "pot13.name", image: "pot13", height: 16, rarity: .uncommon, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot14.name", image: "pot14", height: 16, rarity: .uncommon, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot15.name", image: "pot15", height: 16, rarity: .common, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot16.name", image: "pot16", height: 16, rarity: .common, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot17.name", image: "pot17", height: 16, rarity: .common, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot18.name", image: "pot18", height: 16, rarity: .common, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot19.name", image: "pot19", height: 16, rarity: .uncommon, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot20.name", image: "pot20", height: 16, rarity: .uncommon, anchorPointCoefficient: .init(x: -0.15, y: 0)),
        Pot(name: "pot21.name", image: "pot21", height: 24, rarity: .legendary),
        Pot(name: "pot22.name", image: "pot22", height: 26, rarity: .uncommon),
        Pot(name: "pot23.name", image: "pot23", height: 20, rarity: .rare),
        Pot(name: "pot24.name", image: "pot24", height: 22, rarity: .legendary),
        Pot(name: "pot25.name", image: "pot25", height: 22, rarity: .uncommon),
        Pot(potFeatures: [.narrow], name: "pot26.name", image: "pot26", height: 25, rarity: .common),
        Pot(potFeatures: [.narrow], name: "pot27.name", image: "pot27", height: 18, rarity: .common, anchorPointCoefficient: .init(x: 0, y: 0.05)),
        Pot(potFeatures: [.narrow], name: "pot28.name", image: "pot28", height: 24, rarity: .common),
        Pot(potFeatures: [.narrow], name: "pot29.name", image: "pot29", height: 20, rarity: .common),
        Pot(potFeatures: [.narrow], name: "pot30.name", image: "pot30", height: 15, rarity: .common, anchorPointCoefficient: .init(x: -0.42, y: 0.15)),
        Pot(name: "pot31.name", image: "pot31", height: 26, rarity: .common),
        Pot(name: "pot32.name", image: "pot32", height: 23, rarity: .common),
        Pot(name: "pot33.name", image: "pot33", height: 23, rarity: .common),
        Pot(name: "pot34.name", image: "pot34", height: 23, rarity: .common),
        Pot(name: "pot35.name", image: "pot35", height: 23, rarity: .common),
        Pot(potFeatures: [.narrow], name: "pot36.name", image: "pot36", height: 25, rarity: .common, anchorPointCoefficient: .init(x: -0.32, y: 0.08)),
        Pot(potFeatures: [.narrow], name: "pot37.name", image: "pot37", height: 29, rarity: .common),
        Pot(name: "pot38.name", image: "pot38", height: 10, rarity: .common),
        Pot(potFeatures: [.narrow], name: "pot39.name", image: "pot39", height: 30, rarity: .epic),
        Pot(name: "pot40.name", image: "pot40", height: 25, rarity: .epic),
        Pot(name: "pot41.name", image: "pot41", height: 14, rarity: .rare, anchorPointCoefficient: .init(x: 0, y: 0.28)),
        Pot(potFeatures: [.narrow], name: "pot42.name", image: "pot42", height: 22, rarity: .common, anchorPointCoefficient: .init(x: 0, y: 0.18)),
        Pot(name: "pot43.name", image: "pot43", height: 25, rarity: .legendary),
        Pot(name: "pot44.name", image: "pot44", height: 40, rarity: .legendary, anchorPointCoefficient: .init(x: 0.05, y: 0)),
        Pot(name: "pot45.name", image: "pot45", height: 26, rarity: .uncommon),
        Pot(name: "pot46.name", image: "pot46", height: 25, rarity: .legendary),
        Pot(name: "pot47.name", image: "pot47", height: 25, rarity: .epic, anchorPointCoefficient: .init(x: 0, y: 0.02)),
        Pot(potFeatures: [.narrow], name: "pot48.name", image: "pot48", height: 30, rarity: .legendary),
        Pot(name: "pot49.name", image: "pot49", height: 20, rarity: .epic),
        Pot(potFeatures: [.narrow], name: "pot50.name", image: "pot50", height: 40, rarity: .legendary),
        Pot(potFeatures: [.narrow], name: "pot51.name", image: "pot51", height: 28, rarity: .uncommon, anchorPointCoefficient: .init(x: 0, y: 0.18)),
        Pot(potFeatures: [.narrow], name: "pot52.name", image: "pot52", height: 28, rarity: .uncommon, anchorPointCoefficient: .init(x: 0, y: 0.215)),
        Pot(potFeatures: [.narrow], name: "pot53.name", image: "pot53", height: 28, rarity: .uncommon, anchorPointCoefficient: .init(x: 0, y: 0.215)),
        Pot(potFeatures: [.narrow], name: "pot54.name", image: "pot54", height: 28, rarity: .rare, anchorPointCoefficient: .init(x: 0.1, y: 0.215)),
        Pot(potFeatures: [.narrow], name: "pot55.name", image: "pot55", height: 28, rarity: .rare, anchorPointCoefficient: .init(x: 0.1, y: 0.215)),
        Pot(potFeatures: [.narrow], name: "pot56.name", image: "pot56", height: 35, rarity: .rare),
        Pot(potFeatures: [.narrow], name: "pot57.name", image: "pot57", height: 18, rarity: .epic),
        Pot(potFeatures: [.narrow], name: "pot58.name", image: "pot58", height: 24, rarity: .rare),
        Pot(name: "pot59.name", image: "pot59", height: 22, rarity: .rare, anchorPointCoefficient: .init(x: 0, y: 0.006)),
        Pot(name: "pot60.name", image: "pot60", height: 22, rarity: .rare, anchorPointCoefficient: .init(x: 0, y: 0.006)),
        Pot(name: "pot61.name", image: "pot61", height: 22, rarity: .epic, anchorPointCoefficient: .init(x: 0, y: 0.006)),
        Pot(name: "pot62.name", image: "pot62", height: 20, rarity: .uncommon),
        Pot(potFeatures: [.narrow], name: "pot63.name", image: "pot63", height: 28, rarity: .epic)
    ]
    
    //MARK: - SEEDS
    static let seeds: [Seed] = [
        Seed(name: "seed2.name", image: "seed2", height: 40, rarity: .common),
        Seed(name: "seed3.name", image: "seed3", height: 40, rarity: .common),
        Seed(name: "seed4.name", image: "seed4", height: 45, rarity: .rare, rootCoordinateCoef: .init(x: 0.05, y: 0)),
        Seed(name: "seed5.name", unavailavlePotTypes: [.narrow], image: "seed5", height: 40, rarity: .common),
        Seed(name: "seed6.name", image: "seed6", height: 40, rarity: .common, rootCoordinateCoef: CGPoint(x: 0, y: 0.28)),
        Seed(name: "seed7.name", image: "seed7", height: 40, rarity: .common, rootCoordinateCoef: .init(x: 0.2, y: 0.85)),
        Seed(name: "seed8.name", unavailavlePotTypes: [.narrow], image: "seed8", height: 100, rarity: .legendary),
        Seed(name: "seed9.name", image: "seed9", height: 40, rarity: .legendary),
        Seed(name: "seed10.name", image: "seed10", height: 90, rarity: .epic, rootCoordinateCoef: .init(x: -0.06, y: 0)),
        Seed(name: "seed11.name", unavailavlePotTypes: [.narrow], image: "seed11", height: 70, rarity: .rare),
        Seed(name: "seed12.name", image: "seed12", height: 40, rarity: .rare),
        
        Seed(name: "seed13.name",
             unavailavlePotTypes: [.narrow],
             image: "seed13",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed14.name",
             image: "seed14",
             height: 40,
             rarity: .epic),
        
        Seed(name: "seed15.name",
             unavailavlePotTypes: [.narrow],
             image: "seed15",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed16.name",
             image: "seed16",
             height: 90,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.011, y: 0)),
        
        Seed(name: "seed17.name",
             unavailavlePotTypes: [.narrow],
             image: "seed17",
             height: 35,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed18.name",
             image: "seed18",
             height: 44,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed19.name",
             image: "seed19",
             height: 20,
             rarity: .common),
        
        Seed(name: "seed20.name",
             image: "seed20",
             height: 40,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.345)),
        
        Seed(name: "seed21.name",
             image: "seed21",
             height: 32,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0, y: 0.03)),
        
        Seed(name: "seed22.name",
             image: "seed22",
             height: 50,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.46)),
        
        Seed(name: "seed23.name",
             image: "seed23",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed24.name",
             image: "seed24",
             height: 50,
             rarity: .epic),
        
        Seed(name: "seed25.name",
             image: "seed25",
             height: 30,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed26.name",
             image: "seed26",
             height: 90,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.93)),
        
        Seed(name: "seed27.name",
             image: "seed27",
             height: 50,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0, y: 0.46)),
        
        Seed(name: "seed28.name",
             image: "seed28",
             height: 110,
             rarity: .epic),
        
        Seed(name: "seed29.name",
             image: "seed29",
             height: 35,
             rarity: .uncommon),
        
        Seed(name: "seed30.name",
             image: "seed30",
             height: 35,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0, y: 0.01)),
        
        Seed(name: "seed31.name",
             image: "seed31",
             height: 40,
             rarity: .uncommon),
        
        Seed(name: "seed32.name",
             image: "seed32",
             height: 28,
             rarity: .common),
        
        Seed(name: "seed33.name",
             image: "seed33",
             height: 45,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.1, y: 0.19)),
        
        Seed(name: "seed34.name",
             image: "seed34",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed35.name",
             image: "seed35",
             height: 30,
             rarity: .rare),
        
        Seed(name: "seed36.name",
             unavailavlePotTypes: [.narrow],
             image: "seed36",
             height: 30,
             rarity: .uncommon),
        
        Seed(name: "seed37.name",
             unavailavlePotTypes: [.narrow],
             image: "seed37",
             height: 50,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.05, y: 0)),
        
        Seed(name: "seed38.name",
             image: "seed38",
             height: 27,
             rarity: .common),
        
        Seed(name: "seed39.name",
             image: "seed39",
             height: 40,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed40.name",
             image: "seed40",
             height: 26,
             rarity: .common),
        
        Seed(name: "seed41.name",
             image: "seed41",
             height: 26,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed42.name",
             image: "seed42",
             height: 22,
             rarity: .common),
        
        Seed(name: "seed43.name",
             unavailavlePotTypes: [.narrow],
             image: "seed43",
             height: 23,
             rarity: .uncommon),
        
        Seed(name: "seed44.name",
             image: "seed44",
             height: 38,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.03, y: 0.13)),
        
        Seed(name: "seed45.name",
             image: "seed45",
             height: 44,
             rarity: .uncommon),
        
        Seed(name: "seed46.name",
             image: "seed46",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed47.name",
             image: "seed47",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed48.name",
             image: "seed48",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed49.name",
             image: "seed49",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed50.name",
             unavailavlePotTypes: [.narrow],
             image: "seed50",
             height: 42,
             rarity: .legendary),
        
        Seed(name: "seed51.name",
             image: "seed51",
             height: 37,
             rarity: .common),
        
        Seed(name: "seed52.name",
             image: "seed52",
             height: 68,
             rarity: .rare),
        
        Seed(name: "seed53.name",
             image: "seed53",
             height: 36,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.08, y: 0)),
        
        Seed(name: "seed54.name",
             image: "seed54",
             height: 36,
             rarity: .rare),
        
        Seed(name: "seed55.name",
             image: "seed55",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed56.name",
             image: "seed56",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed57.name",
             image: "seed57",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed58.name",
             image: "seed58",
             height: 36,
             rarity: .rare,
             rootCoordinateCoef: .init(x: -0.08, y: 0)),
        
        Seed(name: "seed59.name",
             unavailavlePotTypes: [.narrow],
             image: "seed59",
             height: 10,
             rarity: .common),
        
        Seed(name: "seed60.name",
             image: "seed60",
             height: 34,
             rarity: .uncommon),
        
        Seed(name: "seed61.name",
             image: "seed61",
             height: 28,
             rarity: .rare,
             rootCoordinateCoef: .init(x: -0.07, y: 0)),
        
        Seed(name: "seed62.name",
             image: "seed62",
             height: 60,
             rarity: .rare),
        
        Seed(name: "seed63.name",
             image: "seed63",
             height: 80,
             rarity: .epic),
        
        Seed(name: "seed64.name",
             unavailavlePotTypes: [.narrow],
             image: "seed64",
             height: 65,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0.08, y: 0)),
        
        Seed(name: "seed65.name",
             unavailavlePotTypes: [.narrow],
             image: "seed65",
             height: 32,
             rarity: .common)
    ]
    
}
