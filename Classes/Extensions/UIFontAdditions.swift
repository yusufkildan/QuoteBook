//
//  UIFontAdditions.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 05/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: - Lato
    
    public class func latoBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size)!
    }
    
    public class func latoMediumFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Medium", size: size)!
    }
    
    public class func latoRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }
    
    public class func latoSemiboldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Semibold", size: size)!
    }
    
    public class func latoHeavyFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Heavy", size: size)!
    }    
}
