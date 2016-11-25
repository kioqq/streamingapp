//
//  SAPlayerViewController.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/25/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SAPlayerViewController: UIViewController {
    
    var closeButton:UIButton!
    
    override func loadView() {
        super.loadView()
        
        self.closeButton = UIButton(type: .system)
        self.closeButton.setTitle("Close", for: .normal)
        self.closeButton.tintColor = UIColor.white
        self.closeButton.addTarget(self, action: #selector(SAPlayerViewController.stopAndCloseAction), for: .touchUpInside)
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        self.closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlString = "\(SAConfig.hlsServerPlayURL)/testo/playlist.m3u8"
        
        let url = URL(string:urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.showsPlaybackControls = false
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
        
        view.addSubview(closeButton)
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        closeButton.frame = CGRect(x: 20, y: 20, width: 120, height: 40)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///
    
    func stopAndCloseAction() {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
