//
//  CustomCellNode.swift
//  BackgroundProperySetDemo
//
//  Created by Andrew on 16/4/27.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class CustomCellNode: ASCellNode {
 
    let childA=ASDisplayNode()
    let childB=ASDisplayNode()
    
    var state = State.Right
    
    override init() {
        super.init()
        usesImplicitHierarchyManagement=true
    }
    
    /**
     设置布局
     
     - parameter constrainedSize: 约束大小
     
     - returns: 计算好的布局
     */
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let specA = ASRatioLayoutSpec(ratio: 1, child: childA)
        specA.flexBasis = ASRelativeDimensionMakeWithPoints(1)
        specA.flexGrow = true
        
        let specB = ASRatioLayoutSpec(ratio: 1, child: childB)
        specB.flexBasis = ASRelativeDimensionMakeWithPoints(1)
        specB.flexGrow = true
        let children = state.isReverse ? [ specB, specA ] : [ specA, specB ]
        let direction: ASStackLayoutDirection = state.isVertical ? .Vertical : .Horizontal
        return ASStackLayoutSpec(direction: direction,
                                 spacing: 20,
                                 justifyContent: .SpaceAround,
                                 alignItems: .Center,
                                 children: children)
    }
    /**
     动画布局
     
     - parameter context:
     */
    override func animateLayoutTransition(context: ASContextTransitioning!) {
        childA.frame=context.initialFrameForNode(childA)
        childB.frame=context.initialFrameForNode(childB)
        let tinyDelay = drand48() / 10
        
        
        UIView.animateWithDuration(0.5, delay: tinyDelay, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: .BeginFromCurrentState, animations: {
            self.childA.frame=context.finalFrameForNode(self.childA)
            self.childB.frame=context.finalFrameForNode(self.childB)
            }, completion: {
            context.completeTransition($0)
        })
        
        
    }
}

enum State {
    case Right
    case up
    case down
    case left
    
    var isVertical : Bool{
        switch self {
        case .up,.down:
            return true
        default:
            return false
        }
    }
    
    var isReverse:Bool{
        switch self {
        case .left,.up:
            return true
        default:
            return false
        }
    }
    
    mutating func advance() {
        switch self {
        case .Right:
            self = .up
        case .up:
            self = .left
        case .left:
            self = .down
        case .down:
            self = .Right
        }
    }
}
