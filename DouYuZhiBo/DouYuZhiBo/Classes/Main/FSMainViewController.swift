//
//  FSMainViewController.swift
//  DouYuZhiBo
//
//  Created by Fat brother on 2019/4/21.
//  Copyright © 2019 Fat brother. All rights reserved.
//

import UIKit

class FSMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCildVC(storyName: "Home")    //首页
        addCildVC(storyName: "Live")    //直播
        addCildVC(storyName: "Follow")  //关注
        addCildVC(storyName: "Profile") //我的
        
    }
    
    /// 添加子控制器
    ///
    /// - Parameter storyName:  子控制器的名字
    private func addCildVC(storyName : String) {
        //1.通过storyboard获取控制器, ()后面的 "!" 号是解包的意思，因为childVC是可选的， addChild的时候是必选的，如果把可选的放进去会报错，这里必须解包!
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        //2.将childVC作为子控制器
        addChild(childVC)
    }
    

}
