//
//  AuthorsTableViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

class AuthorsTableViewController: BaseTableViewController {
    
    fileprivate var authors: [Author]! = []
    fileprivate var filteredAuthors: [Author]! = []
    
    fileprivate var searchBar: CustomSearchBar!
    fileprivate var isSearching: Bool! = false
    fileprivate var searchText: String! = ""
    
    // MARK: Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    fileprivate func commonInit() {
        title = "Authors"
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryTableViewCell.classForCoder(), forCellReuseIdentifier: CategoryTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorInset.left = 66.0
        
        
        searchBar = CustomSearchBar.newAutoLayout()
        searchBar.shouldShowShadowOnBottom = true
        searchBar.delegate = self
        searchBar.tintColor = UIColor.tabBarTintColor()
        searchBar.backgroundColor = UIColor.secondaryBackgroundColor()
        
        view.addSubview(searchBar)
        
        searchBar.autoPin(toTopLayoutGuideOf: self, withInset: 0.0)
        searchBar.autoPinEdge(toSuperviewEdge: ALEdge.left)
        searchBar.autoPinEdge(toSuperviewEdge: ALEdge.right)
        searchBar.autoSetDimension(ALDimension.height, toSize: CustomSearchBarDefaultHeight)
        
        
        var insets = tableView.contentInset
        insets.top = defaultTopInset()
        insets.bottom = defaultBottomInset()
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        loadData(withRefresh: true)
    }
    
    // MARK: - Interface
    
    override func defaultTopInset() -> CGFloat {
        return CustomSearchBarDefaultHeight
    }
    
    // MARK: - Load Data
    
    @discardableResult override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        DatabaseManager.shared.getAllAuthors(charSequence: "") { (authors) in
            self.authors = authors
            self.tableView.reloadData()
            self.finishLoading(withState: ControllerState.none, andMessage: nil)
        }
        
        return true
    }
    
    // MARK: - Configure
    
    fileprivate func configure(CategoryTableViewCell cell: CategoryTableViewCell, withIndexPath indexPath: IndexPath) {
        if indexPath.row >= authors.count {
            return
        }
        
        let author: Author
        
        if isSearching == true {
            author = filteredAuthors[indexPath.row]
        }else {
            author = authors[indexPath.row]
        }
        
        if let name = author.name {
            cell.title = name
        }
        
        if let fileName = author.fileName {
            cell.categoryImage = UIImage(named: fileName)
        }
        
        if let count = author.count {
            cell.count = count
        }
    }
}

// MARK: - UITableViewDelegate

extension AuthorsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        
        if indexPath.row >= authors.count {
            return
        }
        
        let author: Author
        
        if isSearching == true {
            author = filteredAuthors[indexPath.row]
        }else {
            author = authors[indexPath.row]
        }
        
        if let authorName = author.name {
            let controller = QuotesTableViewController(withAuthor: authorName)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension AuthorsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return filteredAuthors.count
        }else {
            return authors.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCellReuseIdentifier) as! CategoryTableViewCell
        
        configure(CategoryTableViewCell: cell, withIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryTableViewCell.cellHeight()
    }
}

// MARK: - CustomSearchBarDelegate

extension AuthorsTableViewController: CustomSearchBarDelegate {
    func customSearchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func customSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filterTheAuthors(searchText)
        }
        
        self.tableView.reloadData()
    }
    
    func customSearchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func customSearchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func filterTheAuthors(_ searchText: String) {
        filteredAuthors = authors.filter({ (author: Author) -> Bool in
            let authorNameMatch = author.name!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return authorNameMatch != nil
        })
    }
}
