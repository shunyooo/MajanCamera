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
    
    let numTileHand = 14
    let numTileCandLine = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

// MARK:BeizePath 描画系
extension CollectionPiViewController{
    
    func drawPointAtImageView(_ point:CGPoint){
        let layer = CAShapeLayer.init()
        layer.frame = imageView.frame
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let path3 = createBeizePath(rect: CGRect.init(x: point.x, y: point.y, width: 3, height: 3))
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
            let layer = CAShapeLayer.init()
            layer.frame = imageView.frame
            layer.strokeColor = UIColor.red.cgColor
            layer.fillColor = UIColor.clear.cgColor
            let path3 = createBeizePath(imageView: imageView, pi: pi)
            layer.path = path3.cgPath
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
        print(#function, gesture.state, tapPoint)
        
        switch gesture.state {
        case .began:
            // 牌のプロット。
            // TODO:近くに点がある場合は、それを移動できるように。
            // TODO:牌の新規作成の場合は、他の牌の大きさの中央値でプロットする。
            drawPointAtImageView(tapPoint)
        case .cancelled:
            break
        case .ended:
            break
        case .failed:
            break
        default:
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
