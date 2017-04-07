//
//  LBSegmentView.h
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//
typedef void(^SegmentItemClicked)(NSString *title,NSInteger tag);
#import <UIKit/UIKit.h>

@interface LBSegmentView : UIView
- (instancetype)initWithItemTitles:(NSArray *)itemTitles;
//@property (nonatomic,copy)void(^SegmentItemClicked)(NSString *title,NSInteger tag);
@property (nonatomic,copy) SegmentItemClicked segmentItemClicked;
-(void)defaultClicked;
@end
