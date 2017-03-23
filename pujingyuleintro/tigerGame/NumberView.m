//
//  NumberView.m
//  MyTigerGame
//
//  Created by JFChen on 17/1/2.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "NumberView.h"
#import "Masonry.h"

@implementation NumberView{
    int _digit;
    int _valdigit;
    NSMutableArray *_mutAry;
    int _maxNum;
}

- (instancetype)initWithDigit:(int)digit valiableDigit:(int)valdigit{
    self = [super init];
    if (self) {
        _digit = digit;
        _valdigit = valdigit;
        if (_digit <= 0) {
            NSLog(@"warning _digit is <= 0");
            return self;
        }
        
        _mutAry = [[NSMutableArray alloc] initWithCapacity:_valdigit];
        for (int i = 0; i < _digit; i++) {
            UIImageView *imgView = [UIImageView new];
            imgView.image = [UIImage imageNamed:@"num_00"];
            [self addSubview:imgView];
            [_mutAry addObject:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.right.equalTo(self.mas_right).offset(-8);
                }else if(i == _digit-1){
                    make.left.equalTo(self.mas_left).offset(8);
                }else{
                    UIImageView *preImgView = _mutAry[i-1];
                    make.right.equalTo(preImgView.mas_left).offset(-2);
                }
                make.width.equalTo(self.mas_width).multipliedBy(1.0/_digit).offset(-((16.0+2.0*(_digit-1))/_digit));
                make.top.equalTo(self.mas_top).offset(2);
                make.bottom.equalTo(self.mas_bottom).offset(-2);
            }];
        }
        
        _maxNum = 1;
        for (int i = 0; i < _valdigit; i++) {
         _maxNum *= 10;
        }
        _maxNum -= 1;
        
        self.layer.cornerRadius = 4.0;
    }
    return self;
}

- (BOOL)changeToNum:(int)num{
    if (num > _maxNum || num < 0) {
        return NO;
    }
    
    _showingNum = num;
    int showingNum = _showingNum;
    for (int i = 0; i < _valdigit; i++) {
        UIImageView *imgView = _mutAry[i];
        int numGe = showingNum % 10;
        showingNum /= 10;
        if (numGe == 0 && showingNum == 0) {
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"num_00"]];
        }else{
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d",numGe]];
        }
    }
    
    return YES;
}

- (BOOL)plus:(int)num{
    _showingNum += num;
    if (_showingNum > _maxNum || _showingNum <= 0) {
        _showingNum -= num;
        return NO;
    }
    
    int showingNum = _showingNum;
    for (int i = 0; i < _valdigit; i++) {
        UIImageView *imgView = _mutAry[i];
        int numGe = showingNum % 10;
        showingNum /= 10;
        if (numGe == 0 && showingNum == 0) {
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"num_00"]];
        }else{
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"num_%d",numGe]];
        }
    }
    return YES;
}

@end
