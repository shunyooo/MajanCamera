//
//  apiSchema.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/08.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import ObjectMapper
import UIKit

class PisSchema: Mappable {
    var pis:[PiSchema] = []
    var image_id = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        pis <- map["pis"]
        image_id <- map["image_id"]
    }
}

class PiSchema: Mappable {
    var name = ""
    var xmin:CGFloat = 0.0
    var ymin:CGFloat = 0.0
    var xmax:CGFloat = 0.0
    var ymax:CGFloat = 0.0
    var conf:CGFloat = 0.0
    var frame:CGRect{ get{return CGRect(x: xmin, y: ymin, width: xmax-xmin, height: ymax-ymin)}
    }
    var index:Int?{ get{return Cons.piIndexes.index(of: self.name)}}
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        xmin <- map["xmin"]
        ymin <- map["ymin"]
        xmax <- map["xmax"]
        ymax <- map["ymax"]
        conf <- map["conf"]
    }
}
