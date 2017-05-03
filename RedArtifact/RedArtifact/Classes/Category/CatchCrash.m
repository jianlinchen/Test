//
//  CatchCrash.m
//  RedArtifact
//
//  Created by LiLu on 16/8/10.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "CatchCrash.h"
@implementation CatchCrash

void uncaughtExceptionHandler(NSException *exception)

{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    
    NSString *reason = [exception reason];
    
    // 异常名称
    
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    DLog(@"%@", exceptionInfo);
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    
    [tmpArr insertObject:reason atIndex:0];
    
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    
//    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",exception.description);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *string=[NSString stringWithFormat:@"*********\nios异常闪退\n%@\n%@\n================================================",dateStr, exception.description];
    NSString *fileName=@"error.log";
    
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        
    {
        
        DLog(@"-------文件不存在，写入文件----------");
        
        NSError *error;

        if([string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error])
            
        {
            DLog(@"------写入文件------success");
        }
        else
        {
            
            DLog(@"------写入文件------fail,error==%@",error);
        }
    }
    
    else//追加写入文件，而不是覆盖原来的文件
        
    {
        
        DLog(@"-------文件存在，追加文件----------");
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
        
        NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        [fileHandle writeData:stringData]; //追加写入数据
        
        [fileHandle closeFile];
        
    }
}  
@end
