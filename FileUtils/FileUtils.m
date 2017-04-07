//
//  FileUtils.m
//  UtilsDemo
//
//  Created by 123 on 16/5/18.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils
/**
 * 判断目录是不存在  如果不存在则创建
 * 返回YES 则说明存在这个目录或则创建这个目录成功
 * 返回NO  则说明这个目录不存在切创建失败
 */
+(BOOL)fileDirectoryIsExist:(NSString *)fileDirectory{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isDirectoryExist=[fileManager fileExistsAtPath:fileDirectory isDirectory:&isDirectory];
    //如果文件存在切是目录
    if(isDirectoryExist && isDirectory){
        NSLog(@"文件存在=======");
        return YES;
    }else{
        BOOL createDirectory=[fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        return createDirectory;
    }
}

/**
 * 判断文件是否存在  如果不存在则创建
 * 返回YES   则说明这个文件存在或则创建成功
 * 返回NO    则说明这个文件不存在切创建失败
 */
+(BOOL)fileIsExist:(NSString *)filePath{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        BOOL result=[fileManager createFileAtPath:filePath contents:nil attributes:nil];
        return  result;
    }
}
/**
 * stringByAppendingPathComponent 会自动帮我们拼接一个“/”
 */
+(void)testFileDirectory{
    ///var/mobile/Applications/CE87C979-E771-4868-89BE-9EEC4B47265C
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"homeDirectory is : %@ ",homeDirectory);
    
    
    
    ///var/mobile/Applications/CE87C979-E771-4868-89BE-9EEC4B47265C/Documents/File
    NSString *path=[[homeDirectory stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"File"];
    NSLog(@"path is : %@ ",path);
    
    ///private/var/mobile/Applications/CE87C979-E771-4868-89BE-9EEC4B47265C/tmp/
    NSString *tempDirectory= NSTemporaryDirectory();
    NSLog(@"tempDirectory is : %@ ",tempDirectory);
    
    
    
    ///var/mobile/Applications/CE87C979-E771-4868-89BE-9EEC4B47265C/Documents
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homeDir=[array objectAtIndex:0];
    NSLog(@"homeDir is : %@ ",homeDir);
}
@end
