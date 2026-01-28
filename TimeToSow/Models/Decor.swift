//
//  Decor.swift
//  TimeToSow
//
//  Created by Nebo on 21.01.2026.
//

import UIKit

enum LocationType: String, Codable {
    case stand, hand, free
}

struct AnimationOptions: Hashable, Codable {
    let duration: Double
    let repeatCount: UInt
    let timeRepetition: Double
}

struct DecorType: Hashable, Identifiable {
    let id: UUID
    let name: String
    let locationType: LocationType
    let animationOptions: AnimationOptions?
    let resourceName: String
    let height: CGFloat
    let width: CGFloat
    let isUnlocked: Bool
    
    var resourceUrl: URL? {
        Bundle.main.url(forResource: resourceName, withExtension: animationOptions == nil ? "png" : "gif")
    }
    
    init(id: UUID, name: String, locationType: LocationType, animationOptions: AnimationOptions?, resourceName: String, height: CGFloat, isUnlocked: Bool) {
        self.id = id
        self.name = name
        self.locationType = locationType
        self.animationOptions = animationOptions
        self.resourceName = resourceName
        self.height = height
        self.isUnlocked = isUnlocked
        
        if animationOptions == nil {
            let image: UIImage? = {
                guard let url = Bundle.main.url(forResource: name, withExtension: "png") else { return nil }
                return UIImage(contentsOfFile: url.path)
            }()
            
            let originalWidth = image?.size.width
            let originalHeight = image?.size.height
            
            if let originalWidth, let originalHeight, originalHeight > 0 {
                width = CGFloat(height) * (originalWidth / originalHeight)
            } else {
                width = CGFloat(height)
            }
        } else {
            width = (Decor.gifAspectRatio(named: name) ?? 1) * height
        }
    }
    
    init(from: DecorTypeModelGRDB) {
        id = from.id
        name = from.name
        locationType = from.locationType
        animationOptions = from.animationOptions
        resourceName = from.resourceName
        height = from.height
        width = from.width
        isUnlocked = from.isUnlocked
    }
    
    init(from: DecorModel) {
        id = UUID()
        name = from.name
        locationType = from.locationType
        animationOptions = from.animationOptions
        resourceName = from.resourceUrl
        height = from.height
        isUnlocked = false
        
        if from.animationOptions == nil {
            let image: UIImage? = {
                guard let url = Bundle.main.url(forResource: from.name, withExtension: "png") else { return nil }
                return UIImage(contentsOfFile: url.path)
            }()
            
            let originalWidth = image?.size.width
            let originalHeight = image?.size.height
            
            if let originalWidth, let originalHeight, originalHeight > 0 {
                width = CGFloat(height) * (originalWidth / originalHeight)
            } else {
                width = CGFloat(height)
            }
        } else {
            width = (Decor.gifAspectRatio(named: name) ?? 1) * height
        }
    }
}

extension DecorType {
    var stableId: String {
        name + "-" + String(locationType.rawValue) + "-" + resourceName
    }
}


struct Decor: Hashable, Identifiable {
    let id: UUID
    
    let decorType: DecorType
    let rootRoomID: UUID
    
    let offsetY: Double
    let offsetX: Double
    
    init(id: UUID = UUID(), decorType: DecorType, rootRoomID: UUID, offsetY: Double, offsetX: Double) {
        self.id = id
        self.decorType = decorType
        self.rootRoomID = rootRoomID
        self.offsetY = offsetY
        self.offsetX = offsetX
    }
    
    init(from: DecorModelGRDB) {
        guard let decorType = from.decorType else {
            fatalError()
        }
        
        self.id = from.id
        self.decorType = DecorType(from: decorType)
        self.rootRoomID = from.rootRoomID
        self.offsetY = from.offsetY
        self.offsetX = from.offsetX
    }
    
    
    //    init(id: UUID, name: String, locationType: LocationType, animationOptions: AnimationOptions?, resourceName: String, positon: CGPoint, height: CGFloat) {
    //        self.id = id
    //        self.name = name
    //        self.locationType = locationType
    //        self.animationOptions = animationOptions
    //        self.resourceName = resourceName
    //        self.positon = positon
    //        self.height = height
    //
    //        if animationOptions == nil {
    //            let image: UIImage? = {
    //                guard let url = Bundle.main.url(forResource: name, withExtension: "png") else { return nil }
    //                return UIImage(contentsOfFile: url.path)
    //            }()
    //
    //            let originalWidth = image?.size.width
    //            let originalHeight = image?.size.height
    //
    //            if let originalWidth, let originalHeight, originalHeight > 0 {
    //                width = CGFloat(height) * (originalWidth / originalHeight)
    //            } else {
    //                width = CGFloat(height)
    //            }
    //        } else {
    //            width = (Decor.gifAspectRatio(named: name) ?? 1) * height
    //        }
    //    }
    
    
    func copy(offsetX: Double? = nil, offsetY: Double? = nil) -> Decor {
        Decor(id: self.id, decorType: self.decorType, rootRoomID: self.rootRoomID, offsetY: offsetY ?? self.offsetY, offsetX: offsetX ?? self.offsetX)
    }
    
    
    static func gifAspectRatio(named resourceName: String) -> CGFloat? {
        let parts = resourceName.split(separator: ".", maxSplits: 1)
        let name = String(parts.first ?? "")
        let ext = parts.count > 1 ? String(parts.last!) : "gif"
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext),
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let height = properties[kCGImagePropertyPixelHeight] as? CGFloat,
              height > 0 else {
            return nil
        }
        
        return width / height
    }
}



