//
//  ViewController.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/24/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit

class SAMainViewController: UIViewController {
    
    var startStreamButton:UIButton!
    var watchStreamButton:UIButton!
    
    func initVars() {
        
        self.startStreamButton = UIButton(type: .system)
        self.startStreamButton.setTitle("Start stream", for: .normal)
        self.startStreamButton.addTarget(self, action: #selector(self.startStreamAction), for: .touchUpInside)
        self.startStreamButton.tintColor = UIColor.red
        self.startStreamButton.layer.borderWidth = 1
        self.startStreamButton.layer.cornerRadius = 5
        self.startStreamButton.layer.borderColor = UIColor.red.cgColor
        
        self.watchStreamButton = UIButton(type: .system)
        self.watchStreamButton.setTitle("Watch stream", for: .normal)
        self.watchStreamButton.addTarget(self, action: #selector(self.watchStreamAction), for: .touchUpInside)
        self.watchStreamButton.layer.borderWidth = 1
        self.watchStreamButton.layer.cornerRadius = 5
        self.watchStreamButton.layer.borderColor = self.watchStreamButton.tintColor.cgColor
        
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

