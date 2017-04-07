//
//  LBDoubleTapView.m
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBDoubleTapView.h"

@implementation LBDoubleTapView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan ==========");
    NSTimeInterval delayTime=0.5;//双击的时间间隔
    UITouch *touch=[touches anyObject];
    switch (touch.tapCount) {
        case 1://单击
            [self performSelector:@selector(singelTapFun) withObject:nil afterDelay:delayTime];
            break;
        case 2://双击  取消点击的延迟触发  实现双击的回调
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singelTapFun) object:nil];
            [self performSelector:@selector(doubleTapFun) withObject:nil afterDelay:delayTime];
            break;
            
        default:
            break;
    }
}
-(void)singelTapFun{
    NSLog(@"单击=========");
    if (self.singleTap) {
        self.singleTap();
    }
}
-(void)doubleTapFun{
    NSLog(@"双击-============");
    if (self.doubleTap) {
        self.doubleTap();
    }
}
@end
