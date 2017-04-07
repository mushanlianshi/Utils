//
//  LBSwitch.h
//  LBTabbarController
//
//  Created by liubin on 16/11/14.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LBSwitchShape){
    LBSwitchShapeOval =1,
    LBSwitchShapeRectangle =2,
};
    /**
     * 自定义一个开关按钮
     */
@interface LBSwitch : UIControl

/** 设置边角的形状 默认LBSwitchShapeOval */
@property (nonatomic, assign)LBSwitchShape shape;
/**
 * 获取开关状态的
 */
@property (nonatomic,getter=isOn) BOOL on;
/** tintColor 正常背景色*/
@property (nonatomic,strong) UIColor *tintColor;
/** 开关on状态的背景色 */
@property (nonatomic,strong) UIColor *onTintColor;
/** 滑块圆圈的颜色*/
@property (nonatomic,strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *tintBorderColor;

@property (nonatomic, strong) UIColor *onTintBorderColor;
/**  设置滑块显示的文字 */
-(void)setOnTitle:(NSString *)onTitle onTitleColor:(UIColor *)onTitleColor offTitle:(NSString *)offTitle offTitleColor:(UIColor *)offTitleColor;
@end
