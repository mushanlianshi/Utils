//
//  LBDoubleTapView.h
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//
typedef void(^SingleTapped)(void);
typedef void(^DoubleTapped)(void);
#import <UIKit/UIKit.h>

/**
 * 封装了一个单击双击的view  可实现单击和双击
 */
@interface LBDoubleTapView : UIView
@property (nonatomic,copy)SingleTapped singleTap;
@property (nonatomic,copy)DoubleTapped doubleTap;
@end
