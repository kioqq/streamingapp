//
//  SARTMPPusher.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/25/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation
import lf
import AVFoundation

/*
 
 var rtmpConnection:RTMPConnection = RTMPConnection()
 var rtmpStream:RTMPStream!
 var sharedObject:RTMPSharedObject!
 var currentEffect:VisualEffect? = nil
 var httpService:HTTPService!
 var httpStream:HTTPStream!
 
 */

class SARTMPPusher {
    
    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    
    var streamKey: String! = "testo"
    
    //
    
    fileprivate static let shared = SARTMPPusher()
    
    static func sharedManager() -> SARTMPPusher {
        return shared
    }
    
    
    func startStream(streamView:GLLFView) {
        
        self.activeAudioSession()
        self.setupRTMPSettings(streamView:streamView)
        
    }
    
    func activeAudioSession() {
        
        let sampleRate:Double = 44_100
        
        do {
            try AVAudioSession.sharedInstance().setPreferredSampleRate(sampleRate)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeVideoChat)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
        
    }
    
    func setupRTMPSettings(streamView:GLLFView) {
        
        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.syncOrientation = true
        rtmpStream.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio), automaticallyConfiguresApplicationAudioSession: false)
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back))
        
        //================================
        
        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSessionPreset1280x720
        ]
        
        //================================
        
        rtmpStream.videoSettings = [
            "width": 1280,
            "height": 720,
        ]
        
        //================================
        
        //rtmpStream.audioSettings["bitrate"] = 32 * 1024
        //rtmpStream.videoSettings["bitrate"] = 480 * 1024
        //rtmpStream.captureSettings["fps"] = 30.0
        
        //================================
        
        streamView.attachStream(rtmpStream)
        
        
//        UIApplication.shared.isIdleTimerDisabled = true
        
        
//        rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(SARTMPPusher.rtmpStatusHandler(_:)), observer: self)
//        rtmpConnection.connect(SAConfig.rtmpServerPushURL)
        
    }
    
    func rotateCamera(position:AVCaptureDevicePosition) {
        
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position))
        
    }
    
    func tapForFocusStreamView(pointOfFocus: CGPoint) {
        
        rtmpStream.setPointOfInterest(pointOfFocus, exposure: pointOfFocus)
        
    }
    
    func stopAndClose() {
        
        UIApplication.shared.isIdleTimerDisabled = false
        rtmpConnection.close()
        rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(SARTMPPusher.rtmpStatusHandler(_:)), observer: self)
        
    }
    
    
    // handler
    
    @objc func rtmpStatusHandler(_ notification:Notification) {
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , let code:String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream!.publish(self.streamKey!)
            default:
                break
            }
        }
    }
    
    
    
    
}
