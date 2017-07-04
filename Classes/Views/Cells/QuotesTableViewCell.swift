//
//  QuotesTableViewCell.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 07/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

let QuotesTableViewCellReuseIdentifier = NSStringFromClass(QuotesTableViewCell.classForCoder())

fileprivate let AvatarViewDimension: CGFloat = 50
fileprivate let DefaultInset: CGFloat = 8.0
fileprivate let CategoryLabelFont = UIFont.latoSemiboldFont(withSize: 14.0)
fileprivate let CategoryLabelDefaultHeight: CGFloat = 18.0

class QuotesTableViewCell: UITableViewCell {
    
    fileprivate var categoryLabel: UILabel!
    fileprivate var categoryLabelWidthConstraint: NSLayoutConstraint!
    
    fileprivate var avatarView: UIImageView!
    fileprivate var quoteLabel: UILabel!
    fileprivate var authorLabel: UILabel!
    
    var category: String! {
        didSet {
            categoryLabel.text = category
            let textSize = category.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - DefaultInset, height: CGFloat.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSFontAttributeName: CategoryLabelFont],
                                                 context: nil)
            
            categoryLabelWidthConstraint.constant = textSize.width + 2.0
        }
    }
    
    var quote: String! {
        didSet {
            quoteLabel.text = quote
        }
    }
    
    var author: String! {
        didSet {
            authorLabel.text = author
        }
    }
    
    var avatar: UIImage! {
        didSet {
            avatarView.image = avatar
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
        categoryLabel = UILabel.newAutoLayout()
        categoryLabel.font = CategoryLabelFont
        categoryLabel.layer.backgroundColor = UIColor.secondaryBackgroundColor().cgColor
        categoryLabel.textColor = UIColor.white
        categoryLabel.layer.cornerRadius = 1.0
        categoryLabel.layer.masksToBounds = true
        
        contentView.addSubview(categoryLabel)
        
        categoryLabel.autoPinEdge(toSuperviewEdge: ALEdge.left)
        categoryLabelWidthConstraint = categoryLabel.autoSetDimension(ALDimension.width, toSize: 0.0)
        categoryLabel.autoSetDimension(ALDimension.height, toSize: CategoryLabelDefaultHeight)
        categoryLabel.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: DefaultInset / 2.0)
        
        
        avatarView = UIImageView.newAutoLayout()
        avatarView.contentMode = UIViewContentMode.scaleAspectFill
        avatarView.layer.cornerRadius = AvatarViewDimension / 2
        avatarView.layer.masksToBounds = true
        
        contentView.addSubview(avatarView)
        
        avatarView.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: DefaultInset)
        avatarView.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: categoryLabel, withOffset: 4.0)
        avatarView.autoSetDimensions(to: CGSize(width: AvatarViewDimension, height: AvatarViewDimension))
        
        
        quoteLabel = UILabel.newAutoLayout()
        quoteLabel.numberOfLines = 2
        quoteLabel.textColor = UIColor.primaryDarkTextColor()
        quoteLabel.font = UIFont.latoRegularFont(withSize: 14.0)
        
        contentView.addSubview(quoteLabel)
        
        quoteLabel.autoPinEdge(ALEdge.top, to: ALEdge.top, of: avatarView)
        quoteLabel.autoPinEdge(ALEdge.left, to: ALEdge.right, of: avatarView, withOffset: DefaultInset)
        quoteLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: DefaultInset)
        
        
        authorLabel = UILabel.newAutoLayout()
        authorLabel.font = UIFont.latoMediumFont(withSize: 14.0)
        authorLabel.textColor = UIColor.lightGray
        
        contentView.addSubview(authorLabel)
        
        authorLabel.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: DefaultInset)
        authorLabel.autoPinEdge(ALEdge.left, to: ALEdge.right, of: avatarView, withOffset: DefaultInset)
        authorLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: DefaultInset)
    }
    
    // MARK: - Cell Height
    
    class func cellHeight() -> CGFloat {
        return DefaultInset * 2 + AvatarViewDimension + CategoryLabelDefaultHeight
    }
}
