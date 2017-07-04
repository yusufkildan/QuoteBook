//
//  QuoteDetailViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 10/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout
import Social

fileprivate let DefaultInset: CGFloat = 8.0
fileprivate let AvatarViewDimension: CGFloat = 80
fileprivate let QuoteLabelFont = UIFont.latoRegularFont(withSize: 14.0)

class QuoteDetailViewController: BaseViewController {
    
    fileprivate var quote: Quote?
    
    fileprivate var avatarView: UIImageView!
    
    fileprivate var quoteLabel: UILabel!
    fileprivate var quoteLabelHeightConstraint: NSLayoutConstraint!
    
    fileprivate var authorLabel: UILabel!
    
    fileprivate var favoriteButton: UIButton!
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    init(withQuote quote: Quote) {
        super.init()
        
        self.quote = quote
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        title = "Quote"
        
        favoriteButton = UIButton(type: UIButtonType.custom)
        favoriteButton.frame = CGRect(x: 0.0, y: 0.0, width: 22.0, height: 44.0)
        favoriteButton.adjustsImageWhenHighlighted = false
        favoriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)),
                                 for: UIControlEvents.touchUpInside)
        
        let shareButton = UIButton(type: UIButtonType.custom)
        shareButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        shareButton.setImage(UIImage(named: "iconShare"), for: UIControlState.normal)
        shareButton.adjustsImageWhenHighlighted = false
        shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)),
                              for: UIControlEvents.touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: shareButton), UIBarButtonItem(customView: favoriteButton)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
    }
    
    // MARK: - View's Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primaryBackgroundColor()
        
        avatarView = UIImageView.newAutoLayout()
        avatarView.contentMode = UIViewContentMode.scaleAspectFill
        avatarView.layer.cornerRadius = AvatarViewDimension / 2
        avatarView.layer.masksToBounds = true
        
        view.addSubview(avatarView)
        
        avatarView.autoAlignAxis(ALAxis.vertical, toSameAxisOf: view)
        avatarView.autoPin(toTopLayoutGuideOf: self, withInset: DefaultInset)
        avatarView.autoSetDimensions(to: CGSize(width: AvatarViewDimension, height: AvatarViewDimension))
        
        
        quoteLabel = UILabel.newAutoLayout()
        quoteLabel.textColor = UIColor.primaryDarkTextColor()
        quoteLabel.numberOfLines = 0
        quoteLabel.font = QuoteLabelFont
        quoteLabel.textAlignment = NSTextAlignment.center
        
        view.addSubview(quoteLabel)
        
        quoteLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: avatarView, withOffset: DefaultInset)
        quoteLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: DefaultInset)
        quoteLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: DefaultInset)
        quoteLabelHeightConstraint = quoteLabel.autoSetDimension(ALDimension.height, toSize: 0.0)
        
        
        authorLabel = UILabel.newAutoLayout()
        authorLabel.font = UIFont.latoMediumFont(withSize: 14.0)
        authorLabel.textColor = UIColor.lightGray
        authorLabel.textAlignment = NSTextAlignment.center
        
        view.addSubview(authorLabel)
        
        authorLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: quoteLabel, withOffset: DefaultInset)
        authorLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: DefaultInset)
        authorLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: DefaultInset)
        
        updateInterface()
    }
    
    // MARK: - Update
    
    fileprivate func updateInterface() {
        guard let quote = quote else {
            return
        }
        
        if let authorName = quote.author_name {
            avatarView.image = UIImage(named: authorName)
            authorLabel.text = authorName
        }
        
        if let quoteText = quote.text?.trim() {
            
            quoteLabel.text = quoteText
            
            let size = CGSize(width: (UIScreen.main.bounds.size.width - (DefaultInset * 2)), height: CGFloat.greatestFiniteMagnitude)
            let textSize = quoteText.boundingRect(with: size,
                                                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                  attributes: [NSFontAttributeName: UIFont.latoRegularFont(withSize: 14.0)],
                                                  context: nil)
            
            quoteLabelHeightConstraint.constant = textSize.height + 2.0
        }
        
        if let favorite = quote.favorite {
            switch favorite {
            case 0:
                favoriteButton.setImage(UIImage(named: "iconFavorite"), for: UIControlState.normal)
            case 1:
                favoriteButton.setImage(UIImage(named: "iconFavoriteSelected"), for: UIControlState.normal)
            default:
                break
            }
        }
    }
    
    // MARK: - Actions
    
    override func backButtonTapped(_ button: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func favoriteButtonTapped(_ button: UIButton) {
        guard let quote = quote else {
            return
        }
        
        if quote.favorite == 0 {
            quote.favorite = 1
        }else {
            quote.favorite = 0
        }
        
        DatabaseManager.shared.updateWith(Quote: quote)
        
        updateInterface()
    }
    
    @objc func shareButtonTapped(_ button: UIButton) {
        guard let quote = quote else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Share with Facebook", style: UIAlertActionStyle.default, handler: { (_) in
            if let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                controller.setInitialText(quote.text! + "-" + quote.author_name!)
                self.present(controller, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Share with Twitter", style: UIAlertActionStyle.default, handler: { (_) in
            if let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                controller.setInitialText(quote.text! + "-" + quote.author_name!)
                self.present(controller, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
