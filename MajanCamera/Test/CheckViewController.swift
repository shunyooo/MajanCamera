//
//  CheckViewController.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/09.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var pis:PisSchema?
    var piImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = piImage
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
//        let layer = CAShapeLayer.init()
//        layer.frame = imageView.frame
//        layer.strokeColor = UIColor.red.cgColor
//        layer.fillColor = UIColor.clear.cgColor
//        let path3 = createBeizePath(rect: imageView.aspectFitFrame!)
//        layer.path = path3.cgPath
//        self.imageView.layer.addSublayer(layer)
        
        if let pis = self.pis{
            
            for pi in pis.pis{
                let layer = CAShapeLayer.init()
                layer.frame = imageView.frame
                layer.strokeColor = UIColor.red.cgColor
                layer.fillColor = UIColor.clear.cgColor
                let path3 = createBeizePath(imageView: imageView, pi: pi)
                layer.path = path3.cgPath
                self.imageView.layer.addSublayer(layer)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createBeizePath(imageView:UIImageView, pi:PiSchema) -> UIBezierPath{
        let imageFrame = imageView.aspectFitFrame
        let pi = posPiInFrame(imageFrame!, pi: pi)
        return createBeizePath(rect: pi.frame)
    }
    
    func createBeizePath(rect:CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY) )
        path.addLine(to: CGPoint(x: rect.maxX , y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
    
    func posPiInFrame(_ frame:CGRect, pi:PiSchema)->PiSchema{
        // フレーム中での座標に変更する。
        pi.xmin = pi.xmin * frame.width + frame.minX
        pi.xmax = pi.xmax * frame.width + frame.minX
        pi.ymin = pi.ymin * frame.height + frame.minY
        pi.ymax = pi.ymax * frame.height + frame.minY
        return pi
    }
    
}
