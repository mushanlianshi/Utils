//
//  FileUtils.h
//  UtilsDemo
//
//  Created by 123 on 16/5/18.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject
/**
 * 判断目录是不存在  如果不存在则创建
 * 返回YES 则说明存在这个目录或则创建这个目录成功
 * 返回NO  则说明这个目录不存在切创建失败
 */
+(BOOL)fileDirectoryIsExist:(NSString *)fileDirectory;
/**
 * 判断文件是否存在  如果不存在则创建
 * 返回YES   则说明这个文件存在或则创建成功
 * 返回NO    则说明这个文件不存在切创建失败
 */
+(BOOL)fileIsExist:(NSString *)filePath;
/**
 * 测试文件的集中路径
 */
+(void)testFileDirectory;
@end
