//
//  Font +.swift
//  TimeToSow
//
//  Created by Nebo on 27.05.2025.
//

import Foundation
import SwiftUI

extension Font {
    
    static func myTitle(_ size: CGFloat) -> Font {
        Font.custom("LoveYaLikeASister-Regular", size: size)
    }
    
    static func myButton(_ size: CGFloat) -> Font {
        Font.custom("SedgwickAve-Regular", size: size)
    }
    
    static func myDescription(_ size: CGFloat) -> Font {
        Font.custom("K2D-ExtraLightItalic", size: size)
    }
    
    static func myNumber(_ size: CGFloat) -> Font {
        Font.custom("K2D-MediumItalic", size: size)
    }
}

extension UIFont {
    static func myTitle(_ size: CGFloat) -> UIFont {
        UIFont(name: "LoveYaLikeASister-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func myButton(_ size: CGFloat) -> UIFont {
        UIFont(name: "SedgwickAve-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func myDescription(_ size: CGFloat) -> UIFont {
        UIFont(name: "K2D-ExtraLightItalic", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func myNumber(_ size: CGFloat) -> UIFont {
        UIFont(name: "K2D-MediumItalic", size: size) ?? .systemFont(ofSize: size)
    }
}
