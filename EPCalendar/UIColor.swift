//
//  UIColor.swift
//  Munchkin
//
//  Created by Kátai Imre on 2016. 10. 18..
//  Copyright © 2016. Munchkin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //! MARK: Calendar
    
    class func weekdayDateColor() -> UIColor {
        return UIColor.init(red: (81/255.0), green: (76/255.0), blue: (67/255.0), alpha: 1.0)
    }
    
    class func weekendDateColor() -> UIColor {
        return UIColor.init(red: (197/255.0), green: (196/255.0), blue: (194/255.0), alpha: 1.0)
    }
    
    class func dayDisabledDateColor() -> UIColor {
        return UIColor.init(red: (197/255.0), green: (196/255.0), blue: (194/255.0), alpha: 1.0)
    }
    
    class func todayDateColor() -> UIColor {
        return UIColor.init(red: 99/255.0, green: 178/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    class func selectedDateColor() -> UIColor {
        return UIColor.init(red: 99/255.0, green: 178/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    class func ignoredDateColor() -> UIColor {
        return UIColor.init(red: (197/255.0), green: (196/255.0), blue: (194/255.0), alpha: 1.0)
    }
    
    class func otherMonthDateColor() -> UIColor {
        return UIColor.clear
    }
    
    class func headerMonthColor() -> UIColor {
        return UIColor.init(red: (99/255.0), green: (178/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    class func outOfDateColor() -> UIColor {
        return UIColor.init(red: (197/255.0), green: (196/255.0), blue: (194/255.0), alpha: 1.0)
    }
    
}
