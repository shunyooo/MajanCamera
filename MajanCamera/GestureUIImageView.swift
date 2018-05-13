//
//  GestureUIImageView.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/13.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class GestureUIImageView: UIImageView {

    var gestureEnabled = true
    
    private var beforePoint = CGPoint.zero
    private var currentScale:CGFloat = 1.0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(self.handleGesture(gesture:)))
        self.addGestureRecognizer(pinchGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        self.addGestureRecognizer(longPressGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        
    }
    
    @objc func handleGesture(gesture: UIGestureRecognizer){
        if let tapGesture = gesture as? UITapGestureRecognizer{
            tap(gesture: tapGesture)
        }else if let pinchGesture = gesture as? UIPinchGestureRecognizer{
            pinch(gesture: pinchGesture)
        }else if let panGesture = gesture as? UIPanGestureRecognizer{
            pan(gesture: panGesture)
        }
    }
    
    private func pan(gesture:UIPanGestureRecognizer){
        if self.gestureEnabled{
            
            if let gestureView = gesture.view{
                
                var translation = gesture.translation(in: gestureView)
                
                if abs(self.beforePoint.x) > 0.0 || abs(self.beforePoint.y) > 0.0{
                    translation = CGPoint(x:self.beforePoint.x + translation.x, y:self.beforePoint.y + translation.y)
                }
                
                switch gesture.state{
                case .changed:
                    let scaleTransform = CGAffineTransform(scaleX: self.currentScale, y: self.currentScale)
                    let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
                    self.transform = scaleTransform.concatenating(translationTransform)
                case .ended , .cancelled:
                    self.beforePoint = translation
                default:
                    NSLog("no action")
                }
            }
        }
    }
    
    private func tap(gesture:UITapGestureRecognizer){
        if self.gestureEnabled{
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.beforePoint = CGPoint.zero
                self.currentScale = 1.0
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func pinch(gesture:UIPinchGestureRecognizer){
        
        if self.gestureEnabled{
            
            var scale = gesture.scale
            if self.currentScale > 1.0{
                scale = self.currentScale + (scale - 1.0)
            }
            switch gesture.state{
            case .changed:
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let transitionTransform = CGAffineTransform(translationX: self.beforePoint.x, y: self.beforePoint.y)
                self.transform = scaleTransform.concatenating(transitionTransform)
            case .ended , .cancelled:
                if scale <= 1.0{
                    self.currentScale = 1.0
                    self.transform = CGAffineTransform.identity
                }else{
                    self.currentScale = scale
                }
            default:
                NSLog("not action")
            }
        }
    }

    
    
}
