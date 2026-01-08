//
//  ShelfType.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

struct ShelfType: Hashable {
    let id: UUID
    let name: String
    let image: String
    let shelfPositions: [ShelfPosition]
    
    init(id: UUID = UUID(), name: String, image: String, shelfPositions: [ShelfPosition]) {
        self.id = id
        self.name = name
        self.image = image
        self.shelfPositions = shelfPositions
    }
    
    init(from: ShelfModel) {
        id = from.id
        name = from.name
        image = from.image
        shelfPositions = from.shelfPositions
    }
}

struct ShelfPosition: Hashable, Codable {
    let coefOffsetY: CGFloat
    let paddingLeading: CGFloat
    let paddingTrailing: CGFloat
}

import Foundation

@objc(ShelfPositionsJSONTransformer)
final class ShelfPositionsJSONTransformer: ValueTransformer {
    
    // Важно: указываем, что преобразуем в Data (NSData)
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    // Преобразование [ShelfPosition] → Data
    override func transformedValue(_ value: Any?) -> Any? {
        guard let positions = value as? [ShelfPosition] else { return nil }
        
        do {
            let data = try JSONEncoder().encode(positions)
            return data
        } catch {
            print("Error encoding shelfPositions: \(error)")
            return nil
        }
    }
    
    // Преобразование Data → [ShelfPosition]
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let positions = try JSONDecoder().decode([ShelfPosition].self, from: data)
            return positions
        } catch {
            print("Error decoding shelfPositions: \(error)")
            return nil
        }
    }
    
    // Регистрация
    static func register() {
        let transformer = ShelfPositionsJSONTransformer()
        let name = NSValueTransformerName("ShelfPositionsJSONTransformer")
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

//@objc(ShelfPositionsTransformer)
//final class ShelfPositionsTransformer: NSSecureUnarchiveFromDataTransformer {
//    
//    // Разрешаем NSArray и ShelfPosition как топ-левел классы
//    override static var allowedTopLevelClasses: [AnyClass] {
//        [NSArray.self, ShelfPosition.self]
//    }
//    
//    // Регистрация transformer'а
//    public static func register() {
//        let transformer = ShelfPositionsTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "ShelfPositionsTransformer"))
//    }
//}
