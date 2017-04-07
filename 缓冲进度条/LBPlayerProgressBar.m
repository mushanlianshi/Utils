//
//  LBPlayerProgressBar.m
//  LBTabbarController
//
//  Created by liubin on 16/11/11.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBPlayerProgressBar.h"

@interface LBPlayerProgressBar()
{
    UIProgressView *progressView;
    UISlider *slider;
}
@end
@implementation LBPlayerProgressBar

-(instancetype)init{
    NSLog(@"LBPlayerProgress init==========");
    if (self=[super init]) {
        progressView=[[UIProgressView alloc] init];
        [progressView setTrackTintColor:[UIColor whiteColor]];
        [progressView setProgressTintColor:[UIColor lightGrayColor]];
        progressView.progress=0;
        [self addSubview:progressView];
        
        slider=[[UISlider alloc] init];
        [slider setMaximumTrackTintColor:[UIColor clearColor]];
        [slider setMinimumTrackTintColor:[UIColor greenColor]];
//        [slider setThumbImage:[slider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
        //ios 7上没有效果
        [slider setThumbTintColor:[UIColor redColor]];
        slider.value=0;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
    }
    return self;
}

-(void)sliderValueChanged:(UISlider *)mslider{
    CGFloat value=mslider.value;
    if (self.valueChangedBlock) {
        self.valueChangedBlock(value);
    }
}
-(void)setProgressValue:(CGFloat)value{
    progressView.progress=value;
}
-(void)setSliderValue:(CGFloat)value{
    slider.value=value;
}

-(void)setProgressBackColor:(UIColor *)backColor frontColor:(UIColor *)frontColor sliderfrontColor:(UIColor *)sliderFrontColor sliderThumColor:(UIColor *)sliderThumColor{
    [progressView setTrackTintColor:backColor];
    [progressView setProgressTintColor:frontColor];
    
    [slider setThumbImage:nil forState:UIControlStateNormal];
    [slider setMinimumTrackTintColor:frontColor];
    [slider setThumbTintColor:sliderThumColor];
    
}
-(void)layoutSubviews{
    NSLog(@"layoutSubviews=============");
    progressView.frame=self.bounds;
    CGRect frame=self.bounds;
    frame.size.height=frame.size.height+1;
    frame.origin.y=-1;
    frame.origin.x=-1;
    frame.size.width+=2;
    slider.frame=frame;
}

@end
