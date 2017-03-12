//
//  CustomSearchBar.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 12/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

let CustomSearchBarDefaultHeight: CGFloat = 44.0

class CustomSearchBar: UIView {
    weak var delegate: CustomSearchBarDelegate!
    
    fileprivate var bottomShadow: UIImageView!
    var searchBar: UISearchBar!
    
    var shouldShowShadowOnBottom: Bool! = false {
        didSet {
            if shouldShowShadowOnBottom == true {
                if let shadow = bottomShadow {
                    shadow.isHidden = false
                    
                    return
                }
                
                bottomShadow = UIImageView.newAutoLayout()
                bottomShadow.image = UIImage(named: "gradientBackgroundBlackTopToBottomSmall")
                
                addSubview(bottomShadow)
                
                bottomShadow.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: self)
                bottomShadow.autoPinEdge(toSuperviewEdge: ALEdge.left)
                bottomShadow.autoPinEdge(toSuperviewEdge: ALEdge.right)
                bottomShadow.autoSetDimension(ALDimension.height, toSize: 5.0)
            } else {
                if let shadow = bottomShadow {
                    shadow.isHidden = false
                }
            }
        }
    }
    
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.primaryBackgroundColor()
        
        searchBar = UISearchBar.newAutoLayout()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        
        addSubview(searchBar)
        
        searchBar.autoPinEdgesToSuperviewEdges()
    }
}

// MARK: - UISearchBarDelegate

extension CustomSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.customSearchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.customSearchBarCancelButtonClicked(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate.customSearchBar(searchBar, shouldChangeTextIn: range, replacementText: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate.customSearchBarSearchButtonClicked(searchBar)
    }
}

// MARK: - CustomSearchBarDelegate

protocol CustomSearchBarDelegate: NSObjectProtocol {
    func customSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func customSearchBarCancelButtonClicked(_ searchBar: UISearchBar)
    func customSearchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func customSearchBarSearchButtonClicked(_ searchBar: UISearchBar)
}
