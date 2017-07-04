//
//  BaseViewController.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 05/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit
import PureLayout

enum KeyboardAction: Int {
    case show
    case hide
}

enum ControllerState {
    case none
    case loading
    case error
}

class BaseViewController: UIViewController {
    private let instanceIdentifier = NSUUID.init().uuidString
    
    lazy var customBackButton: UIButton! = {
        [unowned self] in
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.setImage(UIImage(named: "iconBackButton"), for: UIControlState.normal)
        backButton.adjustsImageWhenHighlighted = false
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        return backButton
        }()
    
    lazy var customCrossButton: UIButton! = {
        [unowned self] in
        let crossButton = UIButton(type: UIButtonType.custom)
        crossButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        crossButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        crossButton.setImage(UIImage(named: ""), for: UIControlState.normal)
        crossButton.adjustsImageWhenHighlighted = false
        crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        return crossButton
        }()
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.commonInit()
    }
    
    private func commonInit() {
        let dnc = NotificationCenter.default
        
        dnc.addObserver(self, selector: #selector(BaseViewController.didReceiveKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        dnc.addObserver(self, selector: #selector(BaseViewController.didReceiveKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        dnc.addObserver(self, selector: #selector(BaseViewController.didReceiveKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        dnc.addObserver(self, selector: #selector(BaseViewController.didReceiveKeyboardDidHideNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        if (shouldShowLogoAsTitleView() && shouldShowNavigationBar()) {
            let logo = UIImage(named: "logoNavigationBar")
            
            let logoView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: (logo?.size.width)!, height: (logo?.size.height)!))
            logoView.image = logo
            
            self.navigationItem.titleView = logoView
        }
        
        if hasBlurredBackground() {
            view.backgroundColor = UIColor.clear
            
            
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
            blurView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(blurView)
            
            blurView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = navigationController {
            controller.setNavigationBarHidden(!shouldShowNavigationBar(), animated: true)
            
            controller.navigationBar.barTintColor = navigationBarTintColor()
            
            controller.navigationBar.titleTextAttributes = [NSFontAttributeName: NavigationBarTitleFont,
                                                            NSForegroundColorAttributeName: navigationBarTitleColor()]
            
            if shouldShowShadowUnderNavigationBar() {
                controller.navigationBar.shadowImage = UIImage(named: "gradientBackgroundBlackTopToBottomSmall")
            } else {
                controller.navigationBar.shadowImage = UIImage()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Interface
    
    func hasBlurredBackground() -> Bool {
        return false
    }
    
    // MARK: - Navigation
    
    func shouldShowNavigationBar() -> Bool {
        return true
    }
    
    func shouldShowShadowUnderNavigationBar() -> Bool {
        return true
    }
    
    func shouldShowLogoAsTitleView() -> Bool {
        return false
    }
    
    func navigationBarTintColor() -> UIColor {
        return UIColor.primaryBackgroundColor()
    }
    
    func navigationBarTitleColor() -> UIColor {
        return UIColor.primaryNavigationComponentColor()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    // MARK: - Insets
    
    func defaultTopInset() -> CGFloat {
        var topInset: CGFloat = 0.0
        
        let application = UIApplication.shared
        
        if application.isStatusBarHidden == false {
            topInset += application.statusBarFrame.height
        }
        
        if shouldShowNavigationBar() {
            if let controller = navigationController {
                topInset += controller.navigationBar.frame.size.height
            }
        }
        
        return topInset
    }
    
    func defaultBottomInset() -> CGFloat {
        guard let controller = self.tabBarController else {
            return 0.0
        }
        
        return controller.tabBar.frame.size.height
    }
    
    // MARK: - UIAlertController
    
    func displayAlertWith(title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        let closeAction = UIAlertAction(title: "Ok",
                                        style: .default,
                                        handler: { (action) -> Void in
                                            alertController.dismiss(animated: true,
                                                                    completion: nil)
        })
        
        alertController.addAction(closeAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    // MARK: - Keyboard Notifications
    
    func didReceiveKeyboardWillShowNotification(_ notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardWillHideNotification(_ notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardDidShowNotification(_ notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardDidHideNotification(_ notification: NSNotification) {
        
    }
    
    func handleInsetsOf(ScrollView scrollView: UIScrollView, forAction action: KeyboardAction, withNotification notification: NSNotification) {
        if ((self.isViewLoaded == true && self.view.window != nil) == false) {
            return
        }
        
        let application = UIApplication.shared
        
        if application.applicationState != UIApplicationState.active {
            return
        }
        
        var insets = scrollView.contentInset
        
        switch action {
        case KeyboardAction.show:
            guard let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] else {
                return
            }
            
            let keyboardHeight = (keyboardFrame as AnyObject).cgRectValue.size.height
            
            insets.bottom = keyboardHeight
            scrollView.scrollIndicatorInsets = insets
            
            insets.bottom += 10.0
        case KeyboardAction.hide:
            insets.bottom = defaultBottomInset()
            
            scrollView.scrollIndicatorInsets = insets
        }
        
        scrollView.contentInset = insets
    }
    
    // MARK: - Actions
    
    func backButtonTapped(_ button: UIButton) {
        
    }
    
    func crossButtonTapped(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Identifier
    
    func uniqueIdentifier() -> String {
        return instanceIdentifier
    }
}
