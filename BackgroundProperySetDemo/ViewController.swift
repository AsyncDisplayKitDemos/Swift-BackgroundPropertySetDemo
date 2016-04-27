//
//  ViewController.swift
//  BackgroundProperySetDemo
//
//  Created by Andrew on 16/4/27.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class ViewController: ASViewController,
ASCollectionDelegate,
ASCollectionDataSource
{

    let itemCount = 1000
    
    var index:Int = 0
    
    let itemSize: CGSize
    let padding: CGFloat
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    
    var activityIndicatorView:UIActivityIndicatorView?
    
    
    init(){
        let layout = UICollectionViewFlowLayout()
        
       
        
        (padding,itemSize)=ViewController.computeLayoutSizeForMainScreen()
        layout.minimumLineSpacing=padding
        layout.minimumInteritemSpacing=padding
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Color", style: .Plain, target: self, action: #selector(ViewController.didTapColorsButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Layout", style: .Plain, target: self, action: #selector(ViewController.didTapLayoutButton))
        
        collectionNode.dataSource=self;
        collectionNode.delegate=self
        
        self.title="后台更新";
        
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        self.view.addSubview(activityIndicatorView!)
//        activityIndicatorView?.center=self.node.view.center
//        activityIndicatorView?.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    static func computeLayoutSizeForMainScreen() ->(padding:CGFloat,itemSize:CGSize){
        let numberOfColumns = 4;
        let screen = UIScreen.mainScreen()
        let scale = screen.scale
        
        let screenWidth = Int(screen.bounds.width*scale)
        let itemWidthPx = (screenWidth - (numberOfColumns - 1)) / numberOfColumns
        let leftOver = screenWidth  - itemWidthPx*numberOfColumns
        
        let paddingPx = leftOver / (numberOfColumns-1)
        let itemDimension = CGFloat(itemWidthPx) / scale
        let padding = CGFloat(paddingPx) / scale
        
        return (padding: padding, itemSize: CGSize(width: itemDimension, height: itemDimension))
    }
    
    
    //MARK: -AsColletionDatasource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
   
    
    func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
       
        
        return  {
            let node = CustomCellNode()
            node.backgroundColor=UIColor.random()
            node.childA.backgroundColor=UIColor.random()
            node.childB.backgroundColor=UIColor.random()
            return node;
        }
    }
  
    
    func collectionView(collectionView: ASCollectionView, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath) -> ASSizeRange {
        return ASSizeRangeMake(itemSize, itemSize)
    }
    
   
    /**
     点击颜色的按钮
     */
    func didTapColorsButton() {
        let currentlyVisibleNodes = collectionNode.view.visibleNodes()
        
        let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        dispatch_async(queue) { 
            for case let node as CustomCellNode in currentlyVisibleNodes{
              node.backgroundColor=UIColor.random()
            }
        }
    }
    /**
     点击布局按钮
     */
    func didTapLayoutButton() {
        let currentlyVisibleNodes = collectionNode.view.visibleNodes()
        let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        
        dispatch_async(queue) { 
            for case let node as CustomCellNode in currentlyVisibleNodes{
                node.state.advance()
                node.setNeedsLayout()
            }
        }
    }
    
    



}

