//
//  NSArray+Log.m
//  UIDemo
//
//  Created by 123 on 16/6/2.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)
/**
 * 重写array的输出日志打印的方法
 */
-(NSString *)descriptionWithLocale:(id)locale{
    NSLog(@"重写array输出的方法");
    NSMutableString *string=[[NSMutableString alloc] init];
    [string appendFormat:@"count is %d ",self.count ];
    [string appendString:@"\n\t("];
    for (id obj in self) {
        //如果是最后一个   就不在最后一个添加逗号  实现和系统的格式一样
        if ([obj isEqual:[self lastObject]]){
            //NSLog(@"%@ is lastObj  不添加逗号",obj);
            [string appendFormat:@"\n\t\"%@\"",obj];
        }else{
            [string appendFormat:@"\n\t\"%@\",",obj];
        }
        
        
    }
    [string appendString:@"\n\t)"];
    return string;
}


//测试用的   如果要掉这个方法  需要导入头文件  而调用类别里重写的方法是不需要导入头文件的
-(NSString *)getArrayContentByIndex{
    NSMutableString *string=[[NSMutableString alloc] init];
    [string appendFormat:@"count is %d ",self.count ];
    [string appendString:@"\n("];
    for (int i=0; i<self.count; i++) {
        [string appendFormat:@"\n\"%@\",",[self objectAtIndex:i]];
    }
    [string appendString:@"\n)"];
    return  string;
}
@end
