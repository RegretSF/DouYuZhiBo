//
//  FSHomeVC.swift
//  DouYuZhiBo
//
//  Created by Fat brother on 2019/4/22.
//  Copyright © 2019 Fat brother. All rights reserved.
//

import UIKit

private let kTitltViewH : CGFloat = 40;

class FSHomeVC: UIViewController {
    
    // MARK:- 定义属性
    private var kNavigationBarH = CGFloat() //导航栏的高度
    
    // MARK:- 懒加载属性
    //标题视图
    private lazy var pageTitleView : FSPageTitleView = {[weak self] in
        //1.设置标题视图的尺寸
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitltViewH)
        //2.设置标题数组
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]

        //3.创建标题视图
        let titleView = FSPageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView;
    }()
    //内容视图
    private lazy var pageContentView : FSPageContentView = { [weak self] in
        //1.设置contentFrame
        let contentH = kScreenH - (kStatusBarH + kNavigationBarH + kTitltViewH)
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitltViewH, width: kScreenW, height: contentH)
        
        //2.确定所有的子控制器
        var childVCs = [UIViewController]()
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.init(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        
        let contentView = FSPageContentView(frame: contentFrame, childVCs: childVCs, parentViewController: self)
        contentView.delegate = self
        
        return contentView;
    }()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //1.获取导航栏的高度
        let kNavigationBarH = self.navigationController?.navigationBar.frame.size.height
        self.kNavigationBarH = kNavigationBarH!
        
        //设置UI界面
        setupUI()
        
    }

}

// MARK:- 设置UI界面
extension FSHomeVC {
    private func setupUI() {
        //0.不需要调整UIScrollerView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加标题视图
        view.addSubview(pageTitleView)
        
        //3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.yellow
    }
    
    private func setupNavigationBar() {
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "home_navigation_left")
        
        //2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        //历史
        let historyItem = UIBarButtonItem(imageName: "home_navigation_history", highImageName: "home_navigation_history_highlight", size: size)
        
        //搜索
        let searchItem = UIBarButtonItem(imageName: "home_navigation_sousuo", highImageName: "home_navigation_sousuo_highlight", size: size)
        
        //扫一扫
        let qrcodeItem = UIBarButtonItem(imageName: "home_navigation_scan", highImageName: "home_navigation_scan_highlight", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem];
    }
    
}

// MARK:- 遵守PageTitleViewDelegate
extension FSHomeVC : PageTitleViewDelegate {
    func pageTitleView(titleView: FSPageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK:- 遵守PageContentViewDelegate
extension FSHomeVC : PageContentViewDelegate {
    func pageContentView(contentView: FSPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
