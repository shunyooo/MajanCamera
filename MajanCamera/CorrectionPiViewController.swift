//
//  CorrectionPiViewController.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/11.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class CollectionPiViewController: UIViewController{
    
    @IBOutlet weak var imageView: GestureUIImageView!
    @IBOutlet weak var detectedPisCollectionView: UICollectionView!
    @IBOutlet weak var candPisCollectionView: UICollectionView!
    
    var pis:PisSchema?
    var piImage:UIImage?
    
    let numTileHand = 14
    let numTileCandLine = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectedPisCollectionView.dataSource = self
        detectedPisCollectionView.delegate = self
        
        candPisCollectionView.dataSource = self
        candPisCollectionView.delegate = self
        
        self.detectedPisCollectionView.backgroundColor = .clear
        self.candPisCollectionView.backgroundColor = .clear
        
        imageView.image = piImage
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        
        
        if let pis = self.pis{
            
            pis.pis.sort(by: {$0.index! < $1.index!})
            
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
    }
    
    @IBAction func toHomeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK:CollectionView系
extension CollectionPiViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case detectedPisCollectionView:
            return numTileHand
        case candPisCollectionView:
            return Cons.piIndexes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PiCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "picell", for: indexPath) as! PiCollectionViewCell
        switch collectionView {
        case detectedPisCollectionView:
            if let pis = pis{
                if pis.pis.count > indexPath.row{
                    cell.setImage(piname: pis.pis[indexPath.row].name)
                }else{
                    cell.setImage(piname: "back")
                }
            }
        case candPisCollectionView:
            cell.setImage(piname: Cons.piIndexes[indexPath.row])
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numAtLine:CGFloat = 0
        switch collectionView {
        case detectedPisCollectionView:
            numAtLine = CGFloat(numTileHand)
        case candPisCollectionView:
            numAtLine = CGFloat(numTileCandLine)
        default:
            break
        }
        
        
        let width = collectionView.bounds.width/numAtLine
        let height = width * 90/66
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK:BeizePath 描画系
extension CollectionPiViewController{
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
