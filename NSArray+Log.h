//
//  NSArray+Log.h
//  UIDemo
//
//  Created by 123 on 16/6/2.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * NSArray的类别方法   主要为了打印看的到数组里的内容
 */
@interface NSArray (Log)
/**
 * 测试用的   如果要掉这个方法  需要导入头文件  而调用类别里重写的方法是不需要导入头文件的
 */
-(NSString *)getArrayContentByIndex;
@end
