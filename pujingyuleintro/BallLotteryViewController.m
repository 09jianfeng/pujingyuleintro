//
//  BallLotteryViewController.m
//  pujingyuelechang
//
//  Created by JFChen on 17/2/25.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "BallLotteryViewController.h"
#import "Masonry.h"

@interface BallLotteryViewController ()
@property (nonatomic, retain) UIWebView *webview;
@end

@implementation BallLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"zucaizixun/index.html"];;
    NSURL *url = [NSURL fileURLWithPath:path];
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    _webview.scrollView.bounces = NO;
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

- (void)btnPressed:(id)sender{
    [self.webview goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
