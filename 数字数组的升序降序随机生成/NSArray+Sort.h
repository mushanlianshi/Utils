//
//  NSArray+Sort.h
//  UIDemoFunction
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 数组的列别  主要封装了数组的升序 降序排列  无序（即打乱一个数组）
 */
@interface NSArray (Sort)
/**
 * 数组的升序排列
 */
-(NSArray *)sortArrayByAscending;
/**
 * 数组的降序排列
 */
-(NSArray *)sortArrayByDescending;
/**
 * 数组的无序排列 即把数组里的数据打乱
 * 取一个0-1的随机数  当随机数==0时按升序排列  ==1时按降序排列  所以是无序的 随机的
 */
-(NSArray *)sortArrayByDisordering;
@end
