//
//  GameAudioPlayer.h
//  MyTigerGame
//
//  Created by JFChen on 17/1/4.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAudioPlayer : NSObject

- (void)playFruitAudio;

- (void)playCoinsAddAudio;

- (void)playBackgroundAudio;

- (BOOL)stopBgAudio;

- (BOOL)stopMusic;

- (void)playWinAudio;

- (void)playLoseAudio;

@end
