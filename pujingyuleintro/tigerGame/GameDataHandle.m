//
//  GameDataHandle.m
//  MyTigerGame
//
//  Created by JFChen on 17/1/3.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "GameDataHandle.h"

static NSString *COINKEY = @"COINKEY";
static NSString *ISFIRST = @"ISFIRST";
static NSString *SIGNINKEY = @"SIGNINKEY";

@implementation GameDataHandle
+ (NSInteger)gameRestCoin{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    BOOL isNotfirst = [[userDef objectForKey:ISFIRST] boolValue];
    if (!isNotfirst) {
        [userDef setObject:@1 forKey:ISFIRST];
        [userDef setObject:@100 forKey:COINKEY];
    }
    
    NSInteger coin = [[userDef objectForKey:COINKEY] integerValue];
    return coin;
}

+ (BOOL)addCoin:(NSInteger)coin{
    NSInteger coins = [GameDataHandle gameRestCoin];
    coins += coin;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithInteger:coins] forKey:COINKEY];
    return YES;
}

+ (BOOL)subsCoin:(NSInteger)coin{
    NSInteger coins = [GameDataHandle gameRestCoin];
    coins -= coin;
    if (coins < 0) {
        return NO;
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithInteger:coins] forKey:COINKEY];
    return YES;
}

+ (BOOL)signIn{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger lastDate = [[userDef objectForKey:SIGNINKEY] integerValue];
    NSInteger nowDate = [[[NSDate alloc] init] timeIntervalSince1970];
    if (lastDate <= 0) {
        [userDef setObject:[NSNumber numberWithInteger:nowDate] forKey:SIGNINKEY];
        return YES;
    }
    
    if ((nowDate - lastDate) > 24*60*60) {
        return YES;
    }else{
        return NO;
    }
    
    return YES;
}
@end
