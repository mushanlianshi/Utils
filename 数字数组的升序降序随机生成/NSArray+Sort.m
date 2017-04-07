//
//  NSArray+Sort.m
//  UIDemoFunction
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "NSArray+Sort.h"

@implementation NSArray (Sort)
/**
 * 数组的升序排列
 */
-(NSArray *)sortArrayByAscending{
    NSArray *result=[self sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        NSLog(@"%@ - %@ %d",obj1,obj2,[obj2 compare:obj1]);
        return [obj1 compare:obj2];
    }];
    return result;
}
/**
 * 数组的降序排列
 */
-(NSArray *)sortArrayByDescending{
    NSArray *result=[self sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        NSLog(@"%@ - %@  %d ",obj1,obj2,[obj2 compare:obj1]);
        //这个block 有返回值  就是比较的结果
        return [obj2 compare:obj1];
    }];
    return  result;
}
/**
 * 数组的无序排列 即把数组里的数据打乱
 * 取一个0-1的随机数  当随机数==0时按升序排列  ==1时按降序排列  所以是无序的 随机的
 */
-(NSArray *)sortArrayByDisordering{
    NSArray *result=[self sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        //取一个0-1的随机数  当随机数==0时按升序排列  ==1时按降序排列  所以是无序的 随机的
        if(arc4random_uniform(2)==0){
            return [obj1 compare: obj2];
        }else{
            return [obj2 compare:obj1];
        }
    }];
    return result;
}
@end
