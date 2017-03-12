//
//  FavoritesTableViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

class FavoritesTableViewController: BaseTableViewController {
    
    private var quotes: [Quote]! = []
    
    private var emptyStateView: EmptyStateView!
    
    // MARK: Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    private func commonInit() {
        title = "My Favorites"
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(QuotesTableViewCell.classForCoder(), forCellReuseIdentifier: QuotesTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        emptyStateView = EmptyStateView.newAutoLayout()
        emptyStateView.isHidden = true
        
        view.addSubview(emptyStateView)
        
        emptyStateView.autoPinEdgesToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData(withRefresh: true)
    }
    
    // MARK: - Load Data
    
    @discardableResult override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        DatabaseManager.shared.getAllFavoriteQuotes { (quotes) in
            if quotes.isEmpty {
                emptyStateView.isHidden = false
                emptyStateView.update(withImage: nil, andMessageTitle: "Nothing here yet!",
                                      andMessageSubtitle: "You haven't got any favorite quote.",
                                      andButtonTitle: nil)
            }else {
                emptyStateView.isHidden = true
            }
            
            self.quotes = quotes
            
            self.tableView.reloadData()
            self.finishLoading(withState: ControllerState.none, andMessage: nil)
        }
        
        return true
    }
    
    // MARK: - Configure
    
    private func configure(QuotesTableViewCell cell: QuotesTableViewCell, withIndexPath indexPath: IndexPath) {
        if indexPath.row >= quotes.count {
            return
        }
        
        let quote = quotes[indexPath.row]
        
        if let categoryName = quote.category_name {
            cell.category = categoryName
        }
        
        if let authorName = quote.author_name {
            cell.avatar = UIImage(named: authorName)
            cell.author = authorName
        }
        
        if let quote = quote.text?.trim() {
            cell.quote = quote
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row >= quotes.count {
            return
        }
        
        let quote = quotes[indexPath.row]
        let controller = QuoteDetailViewController(withQuote: quote)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuotesTableViewCellReuseIdentifier) as! QuotesTableViewCell
        
        configure(QuotesTableViewCell: cell, withIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuotesTableViewCell.cellHeight()
    }
}
