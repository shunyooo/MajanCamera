//
//  Con.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/08.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import Foundation
import UIKit

struct Cons {
    
    struct Api {
//        static let BaseUrl = "http://silver.mind.meiji.ac.jp"
//        static let Port = "49164"
        static let BaseUrl = "http://192.168.61.96"
        static let Port = "8080"
        static let url = "\(Cons.Api.BaseUrl):\(Cons.Api.Port)/api"
    }
    
    static let piIndexes = [
        "m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9",
        "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9",
        "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9",
        "e", "s", "w", "n",
        "haku",
        "hatsu",
        "chun"
        ]
    
}
