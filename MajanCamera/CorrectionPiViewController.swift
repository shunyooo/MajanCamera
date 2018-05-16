//
//  CorrectionPiViewController.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/11.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class CollectionPiViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detectedPisCollectionView: UICollectionView!
    @IBOutlet weak var candPisCollectionView: UICollectionView!
    
    var pis:PisSchema?
    var piImage:UIImage?
    
    var pisPos:PisPosSchema!
    
    let numTileHand = 14
    let numTileCandLine = 9
    
    // 現在ドラッグしている牌のインデックス
    var draggingPiIndex:Int? = nil
    var draggingState:DragState = .none
    var draggingStartPoint:CGPoint = .zero
    
    // DEBUG用
    var testLayer:CAShapeLayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pisPos = PisPosSchema(image_id: (pis?.image_id)!)
        
        setupImageScrollView()
        setupCollectionView()
        drawPisAtImageView(pis)
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
    
    func setupCollectionView(){
        detectedPisCollectionView.dataSource = self
        detectedPisCollectionView.delegate = self
        
        candPisCollectionView.dataSource = self
        candPisCollectionView.delegate = self
        
        self.detectedPisCollectionView.backgroundColor = .clear
        self.candPisCollectionView.backgroundColor = .clear
    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! PiCollectionViewCell
        
        for pipos in pisPos.pis{
            pipos.layer.fillColor = UIColor.clear.cgColor
        }
        
        switch collectionView {
        case detectedPisCollectionView:
            // 該当の図形をハイライト
            if let pis = pisPos{
                if pis.pis.count > indexPath.row{
                    let pi = pis.pis[indexPath.row]
                    pi.layer.fillColor = UIColor(red: 0, green: 100/255, blue: 100/255, alpha: 0.5).cgColor
                    //cell.setImage(piname: pis.pis[indexPath.row].name)
                }else{
                    //cell.setImage(piname: "back")
                }
            }
            
            break
        case candPisCollectionView:
            break
        default:
            break
        }
    }
    
}

// MARK:BeizePath 描画系
extension CollectionPiViewController{
    
    func drawCircleAtImageView(_ point:CGPoint, radius:CGFloat)->CAShapeLayer{
        let layer = CAShapeLayer.init()
        layer.frame = imageView.frame
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let path3 = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
        layer.path = path3.cgPath
        self.imageView.layer.addSublayer(layer)
        return layer
    }
    
    func drawPointAtImageView(_ point:CGPoint, size:CGFloat){
        let layer = CAShapeLayer.init()
        layer.frame = imageView.frame
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let path3 = createBeizePath(rect: CGRect.init(x: point.x, y: point.y, width: size, height: size))
        layer.path = path3.cgPath
        self.imageView.layer.addSublayer(layer)
    }
    
    func drawPisAtImageView(_ pis:PisSchema?){
        if let pis = pis{
            pis.pis.sort(by: {$0.index! < $1.index!})
            for pi in pis.pis{
                drawPiToImageView(pi)
            }
        }
    }
    
    func drawPiToImageView(_ pi:PiSchema?){
        if let pi = pi{
            var layer = CAShapeLayer.init()
            layer.frame = imageView.frame
            layer.strokeColor = UIColor.red.cgColor
            layer.fillColor = UIColor.clear.cgColor
            
            let imageFrame = imageView.aspectFitFrame
            let piInview = posPiInFrame(imageFrame!, pi: pi)
            let path3 = createBeizePath(rect: piInview.frame)
            layer.path = path3.cgPath
            
            self.pisPos.pis.append(PiPosSchema(pi: pi, xminInview: piInview.xmin, yminInview: piInview.ymin, xmaxInview: piInview.xmax, ymaxInview: piInview.ymax, layer: &layer))
            self.imageView.layer.addSublayer(layer)
        }
    }
    
    
    func createBeizePath(imageView:UIImageView, pi:PiSchema) -> UIBezierPath{
        // imageView内のimageのFrameを取得し、
        // そのFrameからimageView上における牌の座標を算出する。
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
    
    func createBeizePath(topLeft:CGPoint, topRight:CGPoint, bottomLeft:CGPoint, bottomRight:CGPoint) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addLine(to: topLeft)
        return path
    }
    
    func posPiInFrame(_ frame:CGRect, pi:PiSchema)->PiSchema{
        // 割合値で表現されている座標をフレーム中での座標に変更する。
        pi.xmin = pi.xmin * frame.width + frame.minX
        pi.xmax = pi.xmax * frame.width + frame.minX
        pi.ymin = pi.ymin * frame.height + frame.minY
        pi.ymax = pi.ymax * frame.height + frame.minY
        return pi
    }

}


// MARK: ImageView ScrollViewDelegate
extension CollectionPiViewController: UIScrollViewDelegate{
    
    func setupImageScrollView(){
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .black
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action:#selector(self.longPress))
        longPressGesture.minimumPressDuration = 0.5
        self.imageView.addGestureRecognizer(longPressGesture)
        
        imageView.image = piImage
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
    }
    
    // ズームしたいUIViewを返却
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        print(#function)
        print(self.scrollView.zoomScale)
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            let newScale = self.scrollView.zoomScale * 3
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) -> Void {
        let tapPoint = gesture.location(in: imageView)
        
        switch gesture.state {
        case .began:
            print(#function, gesture.state.rawValue, tapPoint)
            // 牌のプロット。
            // TODO:近くに点がある場合は、それを移動できるように。
            // 近くのポイントの取得。どの牌のどの点か。
            let (dstate, nearIndex, mindis) = pisPos.findNearPoint(from: tapPoint, threshold: 30)
            self.draggingState = dstate
            self.draggingPiIndex = nearIndex
            if dstate != .none{
                print("近点: \(dstate), \(nearIndex), \(mindis)")
                self.draggingStartPoint = tapPoint
            }else{
                print("近くに点はありません")
            }
            
            // TODO:牌の新規作成の場合は、他の牌の大きさの中央値でプロットする。
            testLayer = drawCircleAtImageView(tapPoint, radius: 30)
        case .cancelled:
            self.draggingState = .none
            break
        case .ended:
            testLayer?.removeFromSuperlayer()
            self.draggingState = .none
            break
        case .failed:
            self.draggingState = .none
            break
        default:
            let pi:PiPosSchema = self.pisPos.pis[draggingPiIndex!]
            let diff = tapPoint.calDiff(from:draggingStartPoint)
            draggingStartPoint = tapPoint
            switch draggingState{
                case .topLeft:
                    pi.topLeft = pi.topLeft.calAdd(with:diff)
                    pi.topRight.y = pi.topLeft.y
                    pi.bottomLeft.x = pi.topLeft.x
                
                case .topRight:
                    pi.topRight = pi.topRight.calAdd(with:diff)
                    pi.topLeft.y = pi.topRight.y
                    pi.bottomRight.x = pi.topRight.x
                
                case .bottomLeft:
                    pi.bottomLeft = pi.bottomLeft.calAdd(with:diff)
                    pi.bottomRight.y = pi.bottomLeft.y
                    pi.topLeft.x = pi.bottomLeft.x
                
                case .bottomRight:
                    pi.bottomRight = pi.bottomRight.calAdd(with:diff)
                    pi.bottomLeft.y = pi.bottomRight.y
                    pi.topRight.x = pi.bottomRight.x
                
                case .none: return
            }
            pi.layer.path = createBeizePath(topLeft: pi.topLeft, topRight: pi.topRight, bottomLeft: pi.bottomLeft, bottomRight: pi.bottomRight).cgPath
            loadViewIfNeeded()
            break
        }
        
        // 保存時には、tapPoint（imageView上での座標）を画像上での座標に変換し、
        // 画像上での座標を保存する。
    }
    
    // ズーム時の矩形を求める
    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        let size = CGSize(
            width: self.scrollView.frame.size.width / scale,
            height: self.scrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }
}
