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
