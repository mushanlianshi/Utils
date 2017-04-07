//
//  NSDictionary+Log.m
//  UIDemo
//
//  Created by 123 on 16/6/2.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

/**
 * 重写NSDictionary的输出日志的方法  
 */
//-(NSString *)descriptionWithLocale:(id)locale{
//    NSLog(@"NSDictionary 的类别 来输出 字典类型的数据   -----   ");
//    NSMutableString *string=[[NSMutableString alloc] init];
////    [string appendFormat:@"total keys count is %d ",[[self allKeys] count]];
//    [string appendString:@"\n\t{"];
//    NSArray *array =[self allKeys];
//    NSLog(@"array is %@ ",array);
//    for (id key in array) {
//        //获取key对应的value  对value进行判断是否是String或则是数组
//        id value=[self objectForKey:key];
//        //如果value是字符串string类型
//        if([value isKindOfClass:[NSString class]]){
//            [string appendFormat:@"\n\t\"%@\" = \"%@\";",key,value];
//        }
//        //如果value的类型是数组Array类型  遍历拼接
//        else if ([value isKindOfClass:[NSArray class]]){
//            NSArray *valueArray=value;
//            [string appendFormat:@"\n\t\"%@\" =  (",key];
//            //在遍历value里的数组  拼接
//            for(id obj in valueArray){
//                if ([obj isKindOfClass:[NSString class]]){
//                    if([obj isEqual:[valueArray lastObject]]){
//                        [string appendFormat:@"\n\t\t\"%@\"",obj];
//                    }else{
//                        [string appendFormat:@"\n\t\t\"%@\",",obj];
//                    }
//                    
//                }else{
//                    NSLog(@"Exception ！！ value 值是数组，但数组里面不是string类型");
//                }
//            }
//            [string appendString:@"\n\t\t);"];
//        }
//        
//        
//    }
//    
//    [string appendString:@"\n\t}"];
//    
//    return  string;
//}

-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *string=[[NSMutableString alloc] init];;
    NSArray *array=[self allKeys];
    [string appendFormat:@"\nkeys count is %d ",array.count];
    string=[self appendDictionary:self byString:string];
    NSUInteger *length=[string length];
    //截取一下是为了  去除最后括号外面的分号
    string=[string substringToIndex:length];
    //    [string appendString:@"\n{"];
    //    //这里没有直接调用appendDictionary是因为这样末尾会出现一个分号;
    //    for(id obj in array){
    //        id value=[dictionary objectForKey:obj];
    //        if([value isKindOfClass:[NSString class]]){
    //
    //        }
    //    }
    //
    //    [string appendString:@"\n}"];
    return  string;

}
/**
 *
 */
-(NSString *)showDictionaryLog{
    NSMutableString *string=[[NSMutableString alloc] init];;
    NSArray *array=[self allKeys];
    [string appendFormat:@"\nkeys count is %d ",array.count];
    string=[self appendDictionary:self byString:string];
    NSUInteger *length=[string length];
    //截取一下是为了  去除最后括号外面的分号
    string=[string substringToIndex:length];
//    [string appendString:@"\n{"];
//    //这里没有直接调用appendDictionary是因为这样末尾会出现一个分号;
//    for(id obj in array){
//        id value=[dictionary objectForKey:obj];
//        if([value isKindOfClass:[NSString class]]){
//            
//        }
//    }
//    
//    [string appendString:@"\n}"];
    return  string;
}

/**
 * 根据传入的数组  把数组转成字符串    用来输出显示  封装成方法方便自己调用自己
 * param string 需要把数组拼接在的哪个字符串
 * param array  是传入的数组 需要转换成字符串的数组
 * return NSString   返回把数组转换成字符串拼接在string上后的字符串
 */
//CFBundleURLSchemes =             (
//wx04a4bb92f9d68e69,
//tencent1101792432,
//wb438057862,
//"rm266744cn.thepaper.paper",
//"app.thepaper.cn"
//);
-(NSString *)appendArray:(NSArray *)array byString :(NSMutableString *)string{
    [string appendString:@"\t("];
    //遍历数组里的内容，判断是字符串或则字典或则数组以及其他
    for(id obj in array){
        //如果是字符串
        if ([obj isKindOfClass:[NSString class]]) {
            //需要判断是否是最后一个  是否在后面添加逗号   最后一个不需要添加逗号
            if([obj isEqual:[array lastObject]]){
                [string appendFormat:@"\n\t%@",obj];
            }else{
                [string appendFormat:@"\n\t%@,",obj];
            }
        }
        
        
        //如果是数组   我们就条用自己这个方法  继续遍历  然后拼接在这个字符串后面
        else if([obj isKindOfClass:[NSArray class]]){
            NSMutableString *tempString=[[NSMutableString alloc] init];
            NSString *str=[self appendArray:obj byString:tempString];
            [string appendString:str];
        }
        
        //如果是字典
        else if([obj isKindOfClass:[NSDictionary class]]){
            NSMutableString *tempString=[[NSMutableString alloc] init];
            NSString *str=[self appendDictionary:obj byString:tempString];
            //根据调用我们封装的方法  把字典转成一个字符串  在拼接在我们这个字符串上
            [string appendString:str];
        }
        //如果是别的类型  我们直接拼接
        else{
            [string appendFormat:@"\n\t%@",obj];
        }
    }
    //拼接结尾的括号
    [string appendString:@"\n\t)"];
    return  string;
}
/**
 * 根据传入的字典  把字典转成字符串    用来输出显示  封装成方法方便自己调用自己
 * param string 需要把字典拼接在的哪个字符串
 * param dictionary  是传入的字典  需要转换成字符串的字典
 * return NSString   返回把数组转换成字符串拼接在string上后的字符串
 */
//NSAppTransportSecurity =     {
//    NSAllowsArbitraryLoads = 1;
//};
-(NSString *)appendDictionary:(NSDictionary *)dictionary byString:(NSMutableString *)string{
    [string appendString:@"\t{"];
    //先获取字典里的所有的keys根据keys来遍历value
    NSArray *keyArray=[dictionary allKeys];
    for(id key in keyArray){
        //根据key获取value  value的类型不固定  我们用id
        id value=[dictionary objectForKey:key];
        //把key拼接上来
        [string appendFormat:@"\n\t%@=",key];
        //判断value的类型  如果是string类型   直接拼接
        if([value isKindOfClass:[NSString class]]){
            [string appendFormat:@"%@;",value];
        }
        //如果是array类型  调用上面的方法
        else if([value isKindOfClass:[NSArray class]]){
            NSMutableString *tempString=[[NSMutableString alloc] init];
            NSString *str=[self appendArray:value byString:tempString];
            [string appendFormat:@"%@;",str];
        }
        //如果是字典类型  调用方法自身来继续
        else if([value isKindOfClass:[NSDictionary class]]){
            NSMutableString *tempString=[[NSMutableString alloc] init];
            NSString *str=[self appendDictionary:value byString:tempString];
            [string appendFormat:@"%@;",str];
        }
        //最后其他别的类型  直接添加
        else{
            [string appendFormat:@"%@;",value];
        }
    }
    [string appendString:@"\n};"];
    return  string;
}
@end
