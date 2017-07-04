//
//  QuotesTableViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 07/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

class QuotesTableViewController: BaseTableViewController {
    
    private var quotes: [Quote]! = []
    private var lastQuoteIndex: Int! = 0
    
    private var category: String?
    private var author: String?
    
    // MARK: Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    init(withCategory category: String) {
        super.init()
        self.category = category
        
        commonInit()
    }
    
    init(withAuthor author: String) {
        super.init()
        self.author = author
        
        commonInit()
    }
    
    private func commonInit() {
        
        if category != nil || author != nil {
            title = "Quotes"
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
        }else {
            title = "All Quotes"
        }
    }
    
    // MARK: - View's Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primaryBackgroundColor()
        
        tableView.register(QuotesTableViewCell.classForCoder(),
                           forCellReuseIdentifier: QuotesTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        var insets = contentInset
        insets?.bottom = defaultBottomInset()
        
        contentInset = insets
        scrollIndicatorInsets = insets
        
        loadData(withRefresh: true)
    }
    
    // MARK: - Interface
    
    override func canPullToRefresh() -> Bool {
        return true
    }
    
    // MARK: - Load Data
    
    @discardableResult override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        if refresh {
            lastQuoteIndex = 0
            quotes = []
            
            self.endRefreshing()
        }
        
        if category != nil {
            DatabaseManager.shared.getQuotesByCategory(category: category!, completion: { (quotes) in
                self.quotes = quotes
                
                self.tableView.reloadData()
                self.finishLoading(withState: ControllerState.none, andMessage: nil)
            })
        } else if author != nil {
            DatabaseManager.shared.getQuotesByAuthor(author: author!, completion: { (quotes) in
                self.quotes = quotes
                
                self.tableView.reloadData()
                self.finishLoading(withState: ControllerState.none, andMessage: nil)
            })
        } else {
            DatabaseManager.shared.getAllQuotes(lastQuoteIndex: lastQuoteIndex, completion: { (quotes) in
                self.canLoadMore = self.lastQuoteIndex < 1030
                
                self.quotes = self.quotes + quotes
                self.lastQuoteIndex = quotes.last?.id
                
                self.tableView.reloadData()
                self.finishLoading(withState: ControllerState.none, andMessage: nil)
            })
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

    // MARK: - Actions
    
    override func backButtonTapped(_ button: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}
