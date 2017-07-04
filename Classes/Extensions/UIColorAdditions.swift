//
//  UIColorAdditions.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 05/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

extension UIColor {
    
    fileprivate class func greenColor() -> UIColor {
        return UIColor(red: 104/255.0, green: 155/255.0, blue: 1/255.0, alpha: 1.0)
    }
    // MARK: - Background
    
    public class func primaryBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    public class func secondaryBackgroundColor() -> UIColor {
        return greenColor()
    }
    
    // MARK: - Navigation
    
    public class func primaryNavigationComponentColor() -> UIColor {
        return UIColor.black
    }
    
    // MARK: - Separator
    
    public class func listSeparatorColor() -> UIColor {
        return UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0)
    }
    
    // MARK: - Text Color
    
    public class func primaryDarkTextColor() -> UIColor {
        return UIColor(red: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
    }

    // MARK: - Tab Bar
    
    public class func tabBarTintColor() -> UIColor {
        return greenColor()
    }
}
