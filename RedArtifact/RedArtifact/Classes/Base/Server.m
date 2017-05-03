//
//  Server.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#define SERVER_DATA_FILE [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/server.data"]

#import "Server.h"

@implementation Server

+ (instancetype)shareInstance {
    static Server *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Server *currentServer = [self getCurrentServer];
        if (currentServer) {
            shareInstance = currentServer;
        } else {
            shareInstance = [[self alloc] init];
        }
    });
    
    return shareInstance;
}

- (void)save {
    [NSKeyedArchiver archiveRootObject:self toFile:SERVER_DATA_FILE];
}

+ (instancetype)getCurrentServer {
    Server *server = [NSKeyedUnarchiver unarchiveObjectWithFile:SERVER_DATA_FILE];
    return server;
}

MJCodingImplementation

@end
