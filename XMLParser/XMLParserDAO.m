//
//  XMLParserDAO.m
//  XMLDemo
//
//  Created by 123 on 16/3/17.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "XMLParserDAO.h"
#import <Foundation/NSXMLParser.h>
#import "ViewController.h"
@implementation XMLParserDAO
@synthesize notesArray=_notesArray;
@synthesize elementName=_elementName;

-(void)start{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"info" ofType:@"xml"];
     NSLog(@"path is %@ ",path);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"file is exist=====");
    }else{
        NSLog(@"file is not exist========");
    }
    //NSURL *url=[NSURL URLWithString:path];
    NSURL *url=[NSURL fileURLWithPath:path];
    NSLog(@"url is %@ ",url);
    NSXMLParser *parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate=self;
    //开始解析
    [parser parse];
}
/**
 * 开始解析xml文件时触发的协议  只触发一次和结束xml解析文档一样只解析一次
 * 可以在开始解析xml文档时进行一些初始化  结束的时候释放一些别的东西
 */
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析xml=====");
    _notesArray=[[NSMutableArray alloc] init];
}
/**
 * 开始解析xml文件标签触发的协议  标签有的会有属性在attributeDict中  注意开始子标签的elementName需要进行判断
 * 我们在这里一般都是创建一个字典  把一个字标签对应的内容放在我们这里创建的字典内  然后把
 * 该字典添加到我们的数组里   方便处理
 */
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    NSLog(@"开始解析标签");
    NSLog(@"elementName is %@ ",elementName);
    _elementName=elementName;
    //如果标签名是子节点的开始标签  获取属性id创建一个字典用来存放这个子节点的内容   添加到数组里供我们使用
    if ([elementName isEqualToString:@"Note"]) {
        NSString *_id=[attributeDict objectForKey:@"id"];
        NSLog(@"attributeDict is %@ ",attributeDict);
        NSLog(@"_id is %@ ",_id);
        //创建一个临时字典用来临时存放
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:_id forKey:@"id"];
        //把新的字典添加到数组里
        [_notesArray addObject:dic];
        [dic release];
    }
    
}
/**
 * 子标签名解析完开始解析对应的内动触发的协议  我们在这里可以对内容进行处理空格和换行的处理
 * 对子标签下的各个标签进行处理  添加到解析自标签创建的字典里  这里我们需要获得子标签创建的
 * 字典  用array lastObject可以获取  然后把他们放到对应的字典里
 */
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"解析到字符串==");
    NSLog(@"string is %@ ",string);
    //去掉字符串中的空格和换行
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //如果取到的内容是空  返回 是空说明是个标签本来就没有字符串
    if ([string isEqualToString:@""]) {
        return;
    }
    //获取最后一个添加的字典    就是我们解析标签时添加的
    NSMutableDictionary *dic=[_notesArray lastObject];
    NSLog(@"dic is %@ ",dic);
    //子标签名字是CDate的处理
    if ([_elementName isEqualToString:@"CDate"]) {
        [dic setObject:string forKey:@"CDate"];
    }
    if ([_elementName isEqualToString:@"Content"]) {
        [dic setObject:string forKey:@"Content"];
    }
    if ([_elementName isEqualToString:@"UserID"]) {
        [dic setObject:string forKey:@"UserID"];
    }
}
/**
 * 结束标签触发的协议
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"标签结束");
    NSLog(@"elementName is %@ ",elementName);
    _elementName=nil;
}
/**
 * 解析失败触发的协议
 */
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"解析失败 %@ ",parseError);
}
/**
 * 解析完触发的协议  我们可以释放一些东西在这个方法里
 */
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析xml结束====");
    NSLog(@"test WIDTH is %f ",WIDTH-5);
    NSLog(@"test height is %f ",HEIGHT-5);
    //解析完毕  我们发送一个notification告诉监听的对象  因为带过去的是数组  就不能用字典参数userInfo带故去了
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmlParserFinish" object:_notesArray userInfo:nil];
    
}
-(NSString *)myFirstBlock:(int)number{
    return @"";
}
@end
