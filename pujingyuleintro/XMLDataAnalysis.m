//
//  XMLDataAnalysis.m
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "XMLDataAnalysis.h"
#import "GDataXMLNode.h"

@interface XMLDataAnalysis()

@property (nonatomic, copy) void (^completeBlocl)(NSDictionary *completeDic);
@property (nonatomic, strong) NSMutableDictionary *dataMutDic;

@end

@implementation XMLDataAnalysis{
    NSString *_xmlPath;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataMutDic = [NSMutableDictionary new];
    }
    return self;
}

- (void)dealloc{
    //线程等待结束继续执行
}

- (void)analysisXMLData:(NSString *)xmlPath completeBlock:(void(^)(NSDictionary *completeDic))completeBlock{
    _xmlPath = xmlPath;
    [self GDataXML];
    completeBlock([_dataMutDic copy]);
}

- (void)GDataXML{
    NSData *data = [[NSData alloc] initWithContentsOfFile:_xmlPath];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *sub = [rootElement elementsForName:@"sub"];
    NSArray *articles = [sub[0] elementsForName:@"article"];
    
    for (GDataXMLElement *student in articles) {
        //获取节点属性
        GDataXMLNode *contentNode = [student attributeForName:@"content"];
        NSString *contentStr = [contentNode stringValue];
        
        
        GDataXMLNode *title = [student attributeForName:@"title"];
        NSString *titleStr = [title stringValue];
        [_dataMutDic setObject:contentStr forKey:titleStr];
    }
//    self.textView.text = self.gdatatext;
}

@end
