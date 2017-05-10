//
//  Extensions.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 4/16/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        
        if secondAgo < minute {
            quotient = secondAgo
            unit = "second"
        } else if secondAgo < hour {
            quotient = secondAgo / minute
            unit = "min"
        } else if secondAgo < day {
            quotient = secondAgo / hour
            unit = "hour"
        } else if secondAgo < week {
            quotient = secondAgo / day
            unit = "day"
        } else if secondAgo < month {
            quotient = secondAgo / week
            unit = "week"
        } else if secondAgo < week{
            quotient = secondAgo / month
            unit = "month"
        } else {
            quotient = secondAgo / year
            unit = "year"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "": "s") ago"
    }
}

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right:NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right{
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}
