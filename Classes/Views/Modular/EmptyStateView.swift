//
//  EmptyStateView.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 12/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//
import UIKit
import PureLayout

class EmptyStateView: UIView {
    weak var delegate: EmptyStateViewDelegate!
    
    fileprivate var imageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var subtitleLabel: UILabel!
    
    fileprivate var actionButton: UIButton!
    fileprivate var actionButtonTopConstraint: NSLayoutConstraint!
    fileprivate var actionButtonHeightConstraint: NSLayoutConstraint!
    fileprivate var actionButtonWidthConstraint: NSLayoutConstraint!
    
    fileprivate var backgroundImageView: UIImageView!
    
    fileprivate var image: UIImage?
    fileprivate var title: String?
    fileprivate var subtitle: String?
    fileprivate var buttonTitle: String?
    
    var shouldShowBackgroundImage: Bool! = false {
        didSet {
            if let view = backgroundImageView {
                view.isHidden = !shouldShowBackgroundImage
            }
        }
    }
    
    var backgroundImage: UIImage! {
        didSet {
            if shouldShowBackgroundImage == true {
                backgroundImageView.image = backgroundImage
            }
        }
    }
    
    //MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(withImage image: UIImage?, andMessageTitle title: String?,andMessageSubtitle subtitle: String, andButtonTitle buttonTitle: String?) {
        super.init(frame: CGRect.zero)
        
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        clipsToBounds = true
        backgroundColor = UIColor.primaryBackgroundColor()
        
        backgroundImageView = UIImageView.newAutoLayout()
        
        addSubview(backgroundImageView)
        
        backgroundImageView.autoPinEdgesToSuperviewEdges()
        
        
        let componentsHolderView = UIView.newAutoLayout()
        componentsHolderView.backgroundColor = UIColor.clear
        
        addSubview(componentsHolderView)
        
        componentsHolderView.autoPinEdge(toSuperviewEdge: ALEdge.left)
        componentsHolderView.autoPinEdge(toSuperviewEdge: ALEdge.right)
        componentsHolderView.autoAlignAxis(toSuperviewAxis: ALAxis.horizontal)
        
        imageView = UIImageView.newAutoLayout()
        imageView.contentMode = UIViewContentMode.center
        
        componentsHolderView.addSubview(imageView)
        
        imageView.autoPinEdge(toSuperviewEdge: ALEdge.top)
        imageView.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
        
        
        titleLabel = UILabel.newAutoLayout()
        titleLabel.font = UIFont.latoBoldFont(withSize: 18.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.primaryDarkTextColor()
        titleLabel.numberOfLines = 0
        
        componentsHolderView.addSubview(titleLabel)
        
        titleLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: imageView, withOffset: 30.0)
        titleLabel.autoPinEdge(toSuperviewEdge: ALEdge.left)
        titleLabel.autoPinEdge(toSuperviewEdge: ALEdge.right)
        
        
        subtitleLabel = UILabel.newAutoLayout()
        subtitleLabel.font = UIFont.latoRegularFont(withSize: 14.0)
        subtitleLabel.textAlignment = NSTextAlignment.center
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.numberOfLines = 0
        
        componentsHolderView.addSubview(subtitleLabel)
        
        subtitleLabel.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: titleLabel, withOffset: 4.0)
        subtitleLabel.autoPinEdge(toSuperviewEdge: ALEdge.left)
        subtitleLabel.autoPinEdge(toSuperviewEdge: ALEdge.right)
        
        
        actionButton = UIButton(type: UIButtonType.custom)
        actionButton.setBackgroundImage(UIImage(named: "buttonBackgroundGreen"), for: UIControlState())
        actionButton.setTitleColor(UIColor.white, for: UIControlState())
        actionButton.titleLabel?.font = UIFont.latoRegularFont(withSize: 14.0)
        actionButton.adjustsImageWhenHighlighted = false
        actionButton.addTarget(self,
                               action: #selector(actionButtonTapped(_:)),
                               for: UIControlEvents.touchUpInside)
        
        componentsHolderView.addSubview(actionButton)
        
        actionButtonTopConstraint = actionButton.autoPinEdge(ALEdge.top,
                                                             to: ALEdge.bottom,
                                                             of: subtitleLabel,
                                                             withOffset: 0.0)
        actionButton.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
        actionButtonHeightConstraint = actionButton.autoSetDimension(ALDimension.height, toSize: 0.0)
        actionButtonWidthConstraint = actionButton.autoSetDimension(ALDimension.width, toSize: 0.0)
        
        
        actionButton.autoPinEdge(ALEdge.bottom, to: ALEdge.bottom, of: componentsHolderView)
        
        updateInterface()
    }
    
    // MARK: - Action
    
    @objc func actionButtonTapped(_ button: UIButton) {
        delegate.emptyStateViewDidTapButton(self)
    }
    
    // MARK: - Update
    
    func update(withImage image: UIImage?, andMessageTitle title: String?, andMessageSubtitle subtitle: String?, andButtonTitle buttonTitle: String?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        
        updateInterface()
    }
    
    fileprivate func updateInterface() {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        actionButton.setTitle(buttonTitle, for: UIControlState())
        
        if let buttonTitle = buttonTitle {
            let titleRect = buttonTitle.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSFontAttributeName: actionButton.titleLabel!.font],
                                                     context: nil)
            
            actionButtonTopConstraint.constant = 20.0
            actionButtonWidthConstraint.constant = titleRect.width + 32.0
            actionButtonHeightConstraint.constant = 34.0
        } else {
            actionButtonTopConstraint.constant = 0.0
            actionButtonWidthConstraint.constant = 0.0
            actionButtonHeightConstraint.constant = 0.0
        }
    }
}

protocol EmptyStateViewDelegate: NSObjectProtocol {
    func emptyStateViewDidTapButton(_ view: EmptyStateView)
}
