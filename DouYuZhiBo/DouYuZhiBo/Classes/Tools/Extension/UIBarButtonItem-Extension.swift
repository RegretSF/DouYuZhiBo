//
//  UIBarButtonItem-Extension.swift
//  DouYuZhiBo
//
//  Created by Fat brother on 2019/4/22.
//  Copyright © 2019 Fat brother. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 便利构造函数：
    //1、以 convention 开头。
    //2、在构造函数中必须明确调用一个设计的h构造函数(self)
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSize.zero) {
        
        //1.创建button
        let btn = UIButton()
        
        //2.设置 button 的常态图片
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        //highImageName默认是没有值的，判断如果 highImageName 有值的时候才会去设置 button 的高亮图片。
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: UIControl.State.highlighted)
        }
        
        //3.size 默认是 CGSize.zero，判断如果 size 有值的时候才会去设置 button 的 frame。
        if size == CGSize.zero { //默认
            btn.sizeToFit()
        }else { //size 有值的时候
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        //4.创建 UIBarButtonItem
        self.init(customView: btn)
    }
    
}

