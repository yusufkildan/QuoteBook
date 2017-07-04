//
//  CategoryTableViewCell.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

let CategoryTableViewCellReuseIdentifier = NSStringFromClass(CategoryTableViewCell.classForCoder())

fileprivate let CategoryImageViewDimension: CGFloat = 50.0
fileprivate let DefaultInset: CGFloat = 8.0

class CategoryTableViewCell: UITableViewCell {
    
    fileprivate var categoryImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    
    fileprivate var badgeLabel: BadgeView!
    
    var categoryImage: UIImage! {
        didSet {
            categoryImageView.image = categoryImage
        }
    }
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    var count: Int! {
        didSet {
            badgeLabel.text = "\(count!)"
        }
    }
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    fileprivate func commonInit() {
        categoryImageView = UIImageView.newAutoLayout()
        categoryImageView.contentMode = UIViewContentMode.scaleAspectFill
        categoryImageView.layer.cornerRadius = CategoryImageViewDimension / 2
        categoryImageView.layer.masksToBounds = true
        
        contentView.addSubview(categoryImageView)
        
        categoryImageView.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: DefaultInset)
        categoryImageView.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: DefaultInset)
        categoryImageView.autoSetDimensions(to: CGSize(width: CategoryImageViewDimension, height: CategoryImageViewDimension))
        
        
        badgeLabel = BadgeView.newAutoLayout()
        badgeLabel.font = UIFont.latoRegularFont(withSize: 14.0)
        badgeLabel.textColor = UIColor.white
        badgeLabel.textAlignment = NSTextAlignment.center
        badgeLabel.badgeBackgroundColor = UIColor.secondaryBackgroundColor()
        
        contentView.addSubview(badgeLabel)
        
        badgeLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: DefaultInset)
        badgeLabel.autoAlignAxis(ALAxis.horizontal, toSameAxisOf: self)
        
        
        titleLabel = UILabel.newAutoLayout()
        titleLabel.textColor = UIColor.primaryDarkTextColor()
        titleLabel.font = UIFont.latoSemiboldFont(withSize: 17.0)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.autoPinEdge(ALEdge.left, to: ALEdge.right, of: categoryImageView, withOffset: DefaultInset)
        titleLabel.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: DefaultInset)
        titleLabel.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: DefaultInset)
        titleLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 50.0)
    }
    
    // MARK: - Cell Height
    
    class func cellHeight() -> CGFloat {
        return CategoryImageViewDimension + DefaultInset * 2
    }
}
