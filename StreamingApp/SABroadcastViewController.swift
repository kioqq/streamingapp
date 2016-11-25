//
//  SABroadcastViewController.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/25/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit
import lf
import AVFoundation
import VideoToolbox

class SABroadcastViewController: UIViewController {
    
    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    let lfView:GLLFView = GLLFView(frame: CGRect.zero)
    let touchView: UIView! = UIView()
    var currentPosition:AVCaptureDevicePosition!
    
    
    var closeButton:UIButton!
    var changeCamera:UIButton!
    
    override func loadView() {
        super.loadView()
        
        self.closeButton = UIButton(type: .system)
        self.closeButton.setTitle("Close", for: .normal)
        self.closeButton.tintColor = UIColor.white
        self.closeButton.addTarget(self, action: #selector(SABroadcastViewController.stopAndCloseAction), for: .touchUpInside)
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        self.closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        self.changeCamera = UIButton(type: .system)
        self.changeCamera.setTitle("Camera", for: .normal)
        self.changeCamera.tintColor = UIColor.white
        self.changeCamera.addTarget(self, action: #selector(SABroadcastViewController.rotateCamera), for: .touchUpInside)
        self.changeCamera.layer.borderWidth = 1
        self.changeCamera.layer.cornerRadius = 5
        self.changeCamera.layer.borderColor = UIColor.white.cgColor
        self.changeCamera.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SABroadcastViewController.tapScreen(_:)))
        self.touchView.addGestureRecognizer(tapGesture)
        self.touchView.frame = view.frame
        self.touchView.backgroundColor = UIColor.clear
        self.touchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        lfView.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        view.addSubview(self.lfView)
        view.addSubview(self.touchView)
        view.addSubview(self.closeButton)
        view.addSubview(self.changeCamera)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SABroadcastViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        // Do any additional setup after loading the view.
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startStream()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = self.view.frame.size
        
        lfView.frame = view.bounds
        touchView.frame = view.bounds
        closeButton.frame = CGRect(x: 20, y: 20, width: 120, height: 40)
        changeCamera.frame = CGRect(x: viewSize.width-140, y: 20, width: 120, height: 40)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // actions
    
    func tapScreen(_ gesture: UIGestureRecognizer) {
        
        if let gestureView = gesture.view , gesture.state == .ended {
            
            let touchPoint: CGPoint = gesture.location(in: gestureView)
            let pointOfFocus: CGPoint = CGPoint(x: touchPoint.x/gestureView.bounds.size.width,
                                                   y: touchPoint.y/gestureView.bounds.size.height)
            
            
            rtmpStream.setPointOfInterest(pointOfFocus, exposure: pointOfFocus)
            
        }
        
    }
    
    func stopAndCloseAction() {
        
        UIApplication.shared.isIdleTimerDisabled = false
        rtmpConnection.close()
        rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(SARTMPPusher.rtmpStatusHandler(_:)), observer: self)

        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    ///
    
    func startStream() {
        
        let sampleRate:Double = 44_100
        
        do {
            
            try AVAudioSession.sharedInstance().setPreferredSampleRate(sampleRate)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeVideoChat)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            
        }
        
        //===============================
        
        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.syncOrientation = true
        rtmpStream.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio), automaticallyConfiguresApplicationAudioSession: false)
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .front))
        
        self.currentPosition = .front
        
        rtmpStream.captureSettings = [
            "fps": 30, // FPS
            "sessionPreset": AVCaptureSessionPresetMedium, // input video width/height
            "continuousAutofocus": true, // use camera autofocus mode
            "continuousExposure": true, //  use camera exposure mode
        ]
        
        rtmpStream.audioSettings = [
            "muted": false, // mute audio
            "bitrate": 32 * 1024,
            "sampleRate": sampleRate,
        ]
        
        self.rotated()
        
        lfView.attachStream(rtmpStream)
        
        //================================
        
        
        UIApplication.shared.isIdleTimerDisabled = true

        rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(SABroadcastViewController.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.connect(SAConfig.rtmpServerPushURL)
        
    }
    
    func rotateCamera() {
        
        let position:AVCaptureDevicePosition = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position))
        
    }
    
    func tapForFocusStreamView(pointOfFocus: CGPoint) {
        
        rtmpStream.setPointOfInterest(pointOfFocus, exposure: pointOfFocus)
        
    }
    
    
    // handlers
    
    @objc func rtmpStatusHandler(_ notification:Notification) {
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , let code:String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream!.publish("testo")
            default:
                break
            }
        }
    }
    
    func rotated() {
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
            
            rtmpStream.videoSettings = [
                "width": 854, // video output width
                "height": 480, // video output height
                "bitrate": 480 * 1024, // video output bitrate
                "profileLevel": kVTProfileLevel_H264_Baseline_3_1, // H264 Profile require "import VideoToolbox"
                "maxKeyFrameIntervalDuration": 2, // key frame / sec
            ]
            
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
            
            rtmpStream.videoSettings = [
                "width": 480, // video output width
                "height": 854, // video output height
                "bitrate": 480 * 1024, // video output bitrate
                "profileLevel": kVTProfileLevel_H264_Baseline_3_1, // H264 Profile require "import VideoToolbox"
                "maxKeyFrameIntervalDuration": 2, // key frame / sec
            ]
        }
        
    }

}
