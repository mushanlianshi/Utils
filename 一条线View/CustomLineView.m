//
//  CustomLineView.m
//  UIDemoFunction
//
//  Created by 123 on 16/7/12.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "CustomLineView.h"

@implementation CustomLineView


/**
 * 重写view的draw方法  我们给他绘制成一条线
 */
-(void)drawRect:(CGRect)rect{
    //1.获取会话的上线文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetAllowsAntialiasing(context, true);
    //设置绘制的颜色
    CGContextSetRGBStrokeColor(context, 240/255.0, 240/255.0, 240/255.0, 0.95);
    CGContextMoveToPoint(context, 0, 0);//起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);//终点坐标
    CGContextStrokePath(context);
}
@end
