//
//  Schema.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/16.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import Foundation
import UIKit

enum DragState:String {
    case none
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class PisPosSchema:NSObject{
    var image_id:Int!
    var pis:[PiPosSchema]! = []
    init(image_id:Int) {
        self.image_id = image_id
    }
    
    func findNearPoint(from:CGPoint, threshold:CGFloat) -> (DragState, Int, CGFloat){
        var nearIndex:Int = 0
        var state:DragState = .none
        var mindis:CGFloat = threshold
        for (i, pis) in self.pis.enumerated(){
            let (dstate, dis) = pis.findNearPoint(from: from, threshold: threshold)
            if dis < mindis{
                mindis = dis
                state = dstate
                nearIndex = i
            }
        }
        return (state, nearIndex, mindis)
    }
}

class PiPosSchema:NSObject{
    var pi:PiSchema!
    var topLeft:CGPoint! = .zero
    var topRight:CGPoint! = .zero
    var bottomLeft:CGPoint! = .zero
    var bottomRight:CGPoint! = .zero
    
    var layer:CAShapeLayer!
    var draging:DragState = .none
    
    init(pi:PiSchema, xminInview:CGFloat, yminInview:CGFloat, xmaxInview:CGFloat, ymaxInview:CGFloat, layer:inout CAShapeLayer) {
        self.pi = pi
        self.topLeft = CGPoint(x: xminInview, y: yminInview)
        self.topRight = CGPoint(x: xmaxInview, y: yminInview)
        self.bottomLeft = CGPoint(x: xminInview, y: ymaxInview)
        self.bottomRight = CGPoint(x: xmaxInview, y: ymaxInview)
        self.layer = layer
    }
    
    /// 近い点を探す。
    ///
    /// - Parameters:
    ///   - from: どの点からか
    ///   - threshold: この距離以下であれば、近いとみなす
    /// - Returns: どの点が近いのか。
    func findNearPoint(from:CGPoint, threshold:CGFloat) -> (DragState, CGFloat) {
        let points = [self.topLeft, self.topRight, self.bottomLeft, self.bottomRight]
        let states:[DragState] = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        var dismin:CGFloat = threshold
        var state:DragState = .none
        for (point, _state) in zip(points, states){
            let dis = from.calDistance(to: point!)
            if dismin > dis{
                dismin = dis
                state = _state
            }
        }
        return (state, dismin)
    }
    
}
