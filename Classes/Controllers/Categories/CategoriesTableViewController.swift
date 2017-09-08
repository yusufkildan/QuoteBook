//
//  CategoriesTableViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

class CategoriesTableViewController: BaseTableViewController {
    
    fileprivate var categories: [Category]! = []
    
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
        title = "Categories"
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryTableViewCell.classForCoder(), forCellReuseIdentifier: CategoryTableViewCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        loadData(withRefresh: true)
    }
    
    // MARK: - Load Data
    
    @discardableResult override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        if refresh {
            self.categories = []
            self.endRefreshing()
        }
        
        DatabaseManager.shared.getCategories { (categories) in
            self.categories = categories
            
            self.tableView.reloadData()
            self.finishLoading(withState: ControllerState.none, andMessage: nil)
        }
        
        return true
    }
    
    // MARK: - Configure
    
    fileprivate func configure(CategoryTableViewCell cell: CategoryTableViewCell, withIndexPath indexPath: IndexPath) {
        if indexPath.row >= categories.count {
            return
        }
        
        let category = categories[indexPath.row]
        
        if let name = category.name {
            cell.title = name
        }
        
        if let fileName = category.fileName {
            cell.categoryImage = UIImage(named: fileName)
        }
        
        if let count = category.count {
            cell.count = count
        }
    }
}

// MARK: - UITableViewDelegate

extension CategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= categories.count {
            return
        }
        
        let category = categories[indexPath.row]
        
        if let categoryName = category.name {
            let controller = QuotesTableViewController(withCategory: categoryName)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension CategoriesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
