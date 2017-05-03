//
//  User.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#define USER_DATA_FILE [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/user.data"]


#import "User.h"

@implementation User

+ (instancetype)sharedInstance {
    static User *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        User *currentUser = [self getCurrentUser];
        
        if (currentUser) {
            sharedInstance = currentUser;
        } else {
            sharedInstance = [[self alloc] init];
        }
    });
    
    return sharedInstance;
}

- (void)save {
    [NSKeyedArchiver archiveRootObject:self toFile:USER_DATA_FILE];
}

+ (instancetype)getCurrentUser {
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:USER_DATA_FILE];
    return user;
}

MJCodingImplementation

@end
