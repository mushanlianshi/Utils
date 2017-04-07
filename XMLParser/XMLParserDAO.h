//
//  XMLParserDAO.h
//  XMLDemo
//
//  Created by 123 on 16/3/17.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserDAO : NSObject<NSXMLParserDelegate>
@property(nonatomic,strong) NSMutableArray *notesArray;
@property(nonatomic,strong) NSString *elementName;
@property(nonatomic,strong) NSString *(^myFirstBlock)(int number);
-(void)start;
@end
