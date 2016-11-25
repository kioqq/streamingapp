//
//  SAStartButton.swift
//  StreamingApp
//
//  Created by kioshimafx on 11/25/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit
import pop

class SAStartButton: UIButton {

    func touchDown() {
        
        self.layer.pop_removeAnimation(forKey: "AnimationScaleBack")
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim?.springBounciness = 10
        anim?.springSpeed = 20
        anim?.toValue = NSValue(cgPoint: CGPoint(x: 0.8, y: 0.8))
        self.layer.pop_add(anim, forKey: "AnimationScale")
        
    }
    
    func touchUpInside() {
        
        self.layer.pop_removeAnimation(forKey: "AnimationScale")
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim?.springBounciness = 10
        anim?.springSpeed = 20
        anim?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        self.layer.pop_add(anim, forKey: "AnimationScaleBack")
        
    }

}
