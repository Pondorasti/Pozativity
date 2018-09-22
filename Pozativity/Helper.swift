//
//  Helper.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 23/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let cornerRadius: CGFloat = 8
}

extension UIColor {
    static let mgPrimary = #colorLiteral(red: 0.1019607843, green: 0.7019607843, blue: 0.2941176471, alpha: 1)
    static let mgDestructive = #colorLiteral(red: 0.8823529412, green: 0.3333333333, blue: 0.3294117647, alpha: 1)
    static let mgInformative = #colorLiteral(red: 0.1882352941, green: 0.737254902, blue: 0.9294117647, alpha: 1)
    static let mgGray = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    static let mgWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let mgHighlight = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    static let mgVodafone = #colorLiteral(red: 0.9019607843, green: 0, blue: 0, alpha: 1)
    
    static let mgShadow: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
    
    static let mgTitle = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    static let mgSubtitle = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    static let mgBody = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
}

extension UIButton {
    func setUp(withColor color: UIColor) {
        layer.cornerRadius = Constants.cornerRadius
        
        backgroundColor = color
        setTitleColor(.mgWhite, for: .normal)
    }
}

extension CALayer {
    static let kfShadowOpacity: Float = 0.2
    static let kfShadowOffset: CGSize = CGSize(width: 0, height: 2)
    static let kfShadowColor: CGColor = UIColor.black.cgColor
    static let kfShadowRadius: CGFloat = 3
    
    func setUpShadow() {
        self.shadowColor = CALayer.kfShadowColor
        self.shadowOffset = CALayer.kfShadowOffset
        self.shadowRadius = CALayer.kfShadowRadius
        self.shadowOpacity = CALayer.kfShadowOpacity
    }
}
