//
//  ViewController.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/24/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit

class SAMainViewController: UIViewController {
    
    var startStreamButton:SAStartButton!
    var watchStreamButton:SAStartButton!
    
    func initVars() {
        
        self.startStreamButton = SAStartButton()
        self.startStreamButton.setTitle("Start stream", for: .normal)
        self.startStreamButton.addTarget(self, action: #selector(self.startStreamAction), for: .touchUpInside)
        self.startStreamButton.addTarget(self.startStreamButton, action: #selector(self.startStreamButton.touchDown), for: UIControlEvents.touchDown)
        self.startStreamButton.addTarget(self.startStreamButton, action: #selector(self.startStreamButton.touchUpInside), for: UIControlEvents.touchUpInside)
        self.startStreamButton.tintColor = UIColor.red
        self.startStreamButton.layer.borderWidth = 1
        self.startStreamButton.layer.cornerRadius = 5
        self.startStreamButton.backgroundColor = UIColor.red
        self.startStreamButton.titleLabel?.textColor = UIColor.white
        self.startStreamButton.titleLabel?.font = UIFont(name: "OpenSans-CondensedLight", size: 17)!
        
        ///
        
        self.watchStreamButton = SAStartButton()
        self.watchStreamButton.setTitle("Watch stream", for: .normal)
        self.watchStreamButton.addTarget(self, action: #selector(self.watchStreamAction), for: .touchUpInside)
        self.watchStreamButton.addTarget(self.watchStreamButton, action: #selector(self.watchStreamButton.touchDown), for: UIControlEvents.touchDown)
        self.watchStreamButton.addTarget(self.watchStreamButton, action: #selector(self.watchStreamButton.touchUpInside), for: UIControlEvents.touchUpInside)
        self.watchStreamButton.layer.borderWidth = 1
        self.watchStreamButton.layer.cornerRadius = 5
        self.watchStreamButton.backgroundColor = self.watchStreamButton.tintColor
        self.watchStreamButton.titleLabel?.textColor = UIColor.white
        self.watchStreamButton.titleLabel?.font = UIFont(name: "OpenSans-CondensedLight", size: 17)!
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.initVars()
        
        view.addSubview(startStreamButton)
        view.addSubview(watchStreamButton)
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "StreamingApp"
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = self.view.frame.size
        
        startStreamButton.frame = CGRect(x: viewSize.width/2-75, y: viewSize.height/2-50, width: 150, height: 40)
        watchStreamButton.frame = CGRect(x: viewSize.width/2-75, y: viewSize.height/2, width: 150, height: 40)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //==============
    // MARK: - actions
    
    func startStreamAction() {
        
        let streamVC = SABroadcastViewController()
        self.present(streamVC, animated: true, completion: nil)
        
    }
    
    func watchStreamAction() {
        
        let playerVC = SAPlayerViewController()
        self.present(playerVC, animated: true, completion: nil)
        
    }
    

}

