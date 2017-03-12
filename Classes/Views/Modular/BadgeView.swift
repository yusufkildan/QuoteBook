//
//  BadgeView.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

class BadgeView: UILabel {
    
    var badgeBackgroundColor: UIColor = UIColor.red {
        didSet {
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var insets: CGSize = CGSize(width: 5, height: 0) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var shadowOpacityBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacityBadge)
        }
    }
    
    var shadowRadiusBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowRadius = shadowRadiusBadge
        }
    }
    
    var shadowColorBadge: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColorBadge.cgColor
        }
    }
    
    var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetBadge
        }
    }
    
    // MARK: - Constructors
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        textAlignment = NSTextAlignment.center
        clipsToBounds = false
    }
    
    // MARK: - Functions
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        var insetsWithBorder = actualInsetsWithBorder()
        let rectWithDefaultInsets = rect.insetBy(dx: -insetsWithBorder.width, dy: insetsWithBorder.height)
        
        if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
            insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
        }
        let result = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
        
        return result
    }
    
    override func drawText(in rect: CGRect) {
        layer.cornerRadius = rect.height / 2
        
        let insetsWithBorder = actualInsetsWithBorder()
        let insets = UIEdgeInsets(
            top: insetsWithBorder.height,
            left: insetsWithBorder.width,
            bottom: insetsWithBorder.height,
            right: insetsWithBorder.width)
        
        let rectWithoutInsets = UIEdgeInsetsInsetRect(rect, insets)
        
        super.drawText(in: rectWithoutInsets)
    }
    
    override func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        let path = UIBezierPath(roundedRect: rectInset, cornerRadius: rect.height/2)
        
        badgeBackgroundColor.setFill()
        path.fill()
        
        if borderWidth > 0 {
            borderColor.setStroke()
            path.lineWidth = borderWidth
            path.stroke()
        }
        
        super.draw(rect)
    }
    
    fileprivate func actualInsetsWithBorder() -> CGSize {
        return CGSize(
            width: insets.width + borderWidth,
            height: insets.height + borderWidth
        )
    }
}
