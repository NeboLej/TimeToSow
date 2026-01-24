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

struct Decor: Hashable, Identifiable {
    let id: UUID
    let name: String
    let locationType: LocationType
    let animationOptions: AnimationOptions?
    let resourceName: String
    let positon: CGPoint
    let height: CGFloat
    let width: CGFloat
    
    init(id: UUID, name: String, locationType: LocationType, animationOptions: AnimationOptions?, resourceName: String, positon: CGPoint, height: CGFloat) {
        self.id = id
        self.name = name
        self.locationType = locationType
        self.animationOptions = animationOptions
        self.resourceName = resourceName
        self.positon = positon
        self.height = height
        
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
    
    init(from: DecorModel) {
        id = UUID()
        name = from.name
        locationType = from.locationType
        animationOptions = from.animationOptions
        resourceName = from.resourceUrl
        positon = .zero
        height = from.height
        
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
    
    func copy(positon: CGPoint) -> Decor {
        Decor(id: self.id, name: self.name, locationType: self.locationType, animationOptions: self.animationOptions, resourceName: self.resourceName, positon: positon, height: self.height)
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



