//
//  NumberView.h
//  MyTigerGame
//
//  Created by JFChen on 17/1/2.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberView : UIView
@property(nonatomic, assign) int showingNum;

- (instancetype)initWithDigit:(int)digit valiableDigit:(int)valdigit;

- (BOOL)changeToNum:(int)num;
- (BOOL)plus:(int)num;

@end
