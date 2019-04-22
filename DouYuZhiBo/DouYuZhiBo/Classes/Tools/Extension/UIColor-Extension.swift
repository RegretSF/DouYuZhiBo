//
//  UIColor-Extension.swift
//  DouYuZhiBo
//
//  Created by Fat brother on 2019/4/22.
//  Copyright © 2019 Fat brother. All rights reserved.
//

import UIKit

extension UIColor {
    // 便利构造函数：
    //1、以 convention 开头。
    //2、在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) { //r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
