//
//  XMLDataAnalysis.h
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLDataAnalysis : NSObject

- (void)analysisXMLData:(NSString *)xmlPath completeBlock:(void(^)(NSDictionary *completeDic))completeBlock;

@end
