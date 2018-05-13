//
//  PiCollectionViewCell.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/12.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class PiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(piname:String){
        self.imageView.image = UIImage.init(named: "pi-\(piname)")
    }
}
