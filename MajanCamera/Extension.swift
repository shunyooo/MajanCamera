//
//  Extention.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/09.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showSimpleAlert(title:String, message:String="", ok_handler:(()->Void)?=nil, cancel_handler:(()->Void)?=nil){
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            if let ok_handler = ok_handler{
                ok_handler()
            }
        })
        alert.addAction(defaultAction)
        
        if let cancel_handler = cancel_handler{
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                cancel_handler()
            })
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension UIImage {
    func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage! {
        bezierPath.apply(CGAffineTransform(translationX: -bezierPath.bounds.origin.x, y: -bezierPath.bounds.origin.y ) )
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        var image = UIImage()
        if let context  = context {
            context.saveGState()
            context.addPath(bezierPath.cgPath)
            if strokeColor != nil {
                strokeColor!.setStroke()
                context.setLineWidth(strokeWidth)
            } else { UIColor.clear.setStroke() }
            fillColor?.setFill()
            context.drawPath(using: .fillStroke)
            image = UIGraphicsGetImageFromCurrentImageContext()!
            context.restoreGState()
            UIGraphicsEndImageContext()
        }
        return image
    }
}



extension UIImageView {
    
    private var aspectFitSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }
    
    var aspectFitFrame: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x + (bounds.size.width - size.width) * 0.5, y: frame.origin.y + (bounds.size.height - size.height) * 0.5), size: size)
        }
    }
    
    var aspectFitBounds: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.size.width * 0.5 - size.width * 0.5, y: bounds.size.height * 0.5 - size.height * 0.5), size: size)
        }
    }
    
    private var aspectFillSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio < heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }
    
    var aspectFillFrame: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x - (size.width - bounds.size.width) * 0.5, y: frame.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }
    
    var aspectFillBounds: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.origin.x - (size.width - bounds.size.width) * 0.5, y: bounds.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }
    
    func imageFrame(_ contentMode: UIViewContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return frame
        case .scaleAspectFit:
            return aspectFitFrame
        case .scaleAspectFill:
            return aspectFillFrame
        case .center:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: frame.origin, size: image.size)
        case .top:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x = frame.origin.x
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x = frame.origin.x
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        }
    }
    
    func imageBounds(_ contentMode: UIViewContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return bounds
        case .scaleAspectFit:
            return aspectFitBounds
        case .scaleAspectFill:
            return aspectFillBounds
        case .center:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: CGPoint.zero, size: image.size)
        case .top:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = bounds.size.width - image.size.width
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x: CGFloat = 0
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x: CGFloat = 0
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        }
    }
}
