//
//  GameAudioPlayer.m
//  MyTigerGame
//
//  Created by JFChen on 17/1/4.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "GameAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameAudioPlayer{
    AVAudioPlayer *_audioPlayer;
    AVAudioPlayer *_friutAudioPlayer;
    NSMutableArray *_audioMut;
    BOOL _stopMusic;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _audioMut = [NSMutableArray new];
    }
    return self;
}

- (void)playFruitAudio{
    if (_stopMusic) {
        return;
    }
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"music_click_correct" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    _friutAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [_friutAudioPlayer prepareToPlay];
    [_friutAudioPlayer play];
    [_audioMut addObject:_friutAudioPlayer];
}

- (void)playCoinsAddAudio{
    
}

- (void)playBackgroundAudio{
    [_audioMut removeAllObjects];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"mary" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    _audioPlayer.numberOfLoops = -1;
    _audioPlayer.volume = 0.2;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (BOOL)stopBgAudio{
    if (_audioPlayer.playing) {
        [_audioPlayer pause];
        return NO;
    }else{
        [_audioPlayer play];
        return YES;
    }
}

- (BOOL)stopMusic{
    _stopMusic = !_stopMusic;
    
    if (_stopMusic && _friutAudioPlayer) {
        [_friutAudioPlayer pause];
    }else{
    }
    
    return _stopMusic;
}

- (void)playWinAudio{
    if (_stopMusic) {
        return;
    }
    
    [_audioMut removeAllObjects];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    _friutAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [_friutAudioPlayer prepareToPlay];
    [_friutAudioPlayer play];
}

- (void)playLoseAudio{
    if (_stopMusic) {
        return;
    }
    
    [_audioMut removeAllObjects];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"loose" ofType:@"wav"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    _friutAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [_friutAudioPlayer prepareToPlay];
    [_friutAudioPlayer play];
}

@end
