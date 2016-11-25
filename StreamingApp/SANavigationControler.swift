//
//  GANavigationControler.swift
//  GossipApp
//
//  Created by kioshimafx on 7/10/16.
//  Copyright © 2016 FXSolutions. All rights reserved.
//

import UIKit

class SANavigationControler: UINavigationController {
    
    init(rootVC: UIViewController) {
        super.init(rootViewController: rootVC)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleDict = [NSFontAttributeName : UIFont(name: "OpenSans-CondensedBold", size: 20)!, NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationBar.titleTextAttributes = titleDict
        self.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

}
