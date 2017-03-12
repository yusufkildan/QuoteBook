//
//  MainViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 05/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    var previousController: UIViewController?
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    // MARK: View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.tabBarTintColor()
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage(named: "gradientBackgroundBlackBottomToTopSmall")
        
        
        let quotesViewController = QuotesTableViewController()
        let quotesNavigationController = BaseNavigationController(rootViewController: quotesViewController)
        quotesNavigationController.tabBarItem = UITabBarItem(title: "Quotes", image: UIImage(named: "tabBarQuotes"), tag: 0)
        
        let categoriesViewController = CategoriesTableViewController()
        let categoriesNavigationController = BaseNavigationController(rootViewController: categoriesViewController)
        categoriesNavigationController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "tabBarCategories"), tag: 1)
        
        
        let authorsViewController = AuthorsTableViewController()
        let authorsNavigationController = BaseNavigationController(rootViewController: authorsViewController)
        authorsNavigationController.tabBarItem = UITabBarItem(title: "Authors", image: UIImage(named: "tabBarAuthors"), tag: 2)
        
        
        let favoritesViewController = FavoritesTableViewController()
        let favoritesNavigationController = BaseNavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "My Favorites", image: UIImage(named: "tabBarFavorites"), tag: 3)

        
        viewControllers = [quotesNavigationController,categoriesNavigationController,  authorsNavigationController, favoritesNavigationController]
    }
}

// MARK: - UITabBarControllerDelegate

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if previousController == viewController {
            if let navVC = viewController as? BaseNavigationController, let vc = navVC.viewControllers.first as? QuotesTableViewController {
                if vc.isViewLoaded && vc.view.window != nil {
                    vc.tableView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
        
        previousController = viewController
    }
}
