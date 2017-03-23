//
//  TwentyOneViewController.m
//  pujingyuleintro
//
//  Created by JFChen on 17/3/16.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "TwentyOneViewController.h"
#import "Masonry.h"

@interface TwentyOneViewController ()
@property (nonatomic, retain) UIWebView *webview;
@end

@implementation TwentyOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"twentyone/blackjack.htm"];;
    NSURL *url = [NSURL fileURLWithPath:path];
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    _webview.scrollView.bounces = NO;
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5.0;
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

- (void)btnBackPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
