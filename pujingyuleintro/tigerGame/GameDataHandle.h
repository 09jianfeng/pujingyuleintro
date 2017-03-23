//
//  GameDataHandle.h
//  MyTigerGame
//
//  Created by JFChen on 17/1/3.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDataHandle : NSObject
+ (NSInteger)gameRestCoin;
+ (BOOL)addCoin:(NSInteger)coin;
+ (BOOL)subsCoin:(NSInteger)coin;

+ (BOOL)signIn;
@end
