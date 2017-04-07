//
//  LBPlayerProgressBar.h
//  LBTabbarController
//
//  Created by liubin on 16/11/11.
//  Copyright © 2016年 lb. All rights reserved.
//


typedef void(^SliderValueChangedBlock)(CGFloat value);
#import <UIKit/UIKit.h>

/**
 * 进度条 缓冲条的封装
 */
@interface LBPlayerProgressBar : UIView
@property (nonatomic,copy)SliderValueChangedBlock valueChangedBlock;
/** 设置进度条缓冲条的颜色 */
-(void)setProgressBackColor:(UIColor *)backColor frontColor:(UIColor *)frontColor sliderfrontColor:(UIColor *)sliderFrontColor sliderThumColor :(UIColor *)sliderThumColor;
/** 设置缓冲的进度条 */
-(void)setProgressValue:(CGFloat)value;
/** 设置当前播放的进度 */
-(void)setSliderValue:(CGFloat)value;

@end
