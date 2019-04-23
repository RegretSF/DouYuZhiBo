//
//  FSPageContentView.swift
//  DouYuZhiBo
//
//  Created by Fat brother on 2019/4/22.
//  Copyright © 2019 Fat brother. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : FSPageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

let contentCellID = "ContentCellID"

class FSPageContentView: UIView {
    
    // MARK:- 定义属性
    private var childVCs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?  //声明代理
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        
        return collectionView
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK:- 设置UI界面
extension FSPageContentView {
    private func setupUI() {
        //1.将所有的子控制器添加到父类控制器中
        for childVC in childVCs {
            parentViewController?.addChild(childVC)
        }
        
        //2.添加UICollectionView
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
}

// MARK:- 遵守UICollectionViewDataSource、UICollectionViewDelegate
extension FSPageContentView : UICollectionViewDataSource,UICollectionViewDelegate {
    //设置组内行数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    //细化单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        
        //2.给cell设置内容
        //防止循环利用cell时多次添加 childVC.view ，所以在添加childVC.view之前先把之前缓存的视图给移除
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
        
    }
    
    //开始滑动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    //监听滚动的变化
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        //1.获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {  //左滑
            //1.计算progress,floor是取整的意思
            let ratio = currentOffsetX / scrollViewW
            progress = ratio - floor(ratio)
            
            //2.计算sourceIndex
            sourceIndex = Int(ratio)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
                progress = 1
            }
            
            //4.如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            print("ration:\(ratio) floor(ratio):\(floor(ratio))")
            print("progress:\(progress)")
            
        }else { //右滑
            //1.计算progress
            let ratio = currentOffsetX / scrollViewW
            progress = 1 - (ratio - floor(ratio))
            
            //2.计算targetIndex
            targetIndex = Int(ratio)
            
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
        }
        
        //3.将progress/targetIndex/sourceIndex传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
}

// MARK:- 对外暴露的方法
extension FSPageContentView {
    func setCurrentIndex(currentIndex : Int) {
        //1.记录需要禁止执行的代理方法
        isForbidScrollDelegate = true
        
        //2.滑动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
