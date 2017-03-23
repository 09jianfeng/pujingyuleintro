//
//  MainTableViewController.m
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "MainTableViewController.h"
#import "DetailTableViewController.h"
#import "Masonry.h"
#import "BallLotteryViewController.h"
#import "TigerViewController.h"
#import "GDTSplashAd.h"
#import "TwentyOneViewController.h"

static NSString *GDTAPPID = @"1105153685";
static NSString *GDTMOBINTERSTITIALAPPKEY = @"4040801912471296";
static NSString *GDTSPLASHAPPKEY = @"4020907982979295";

@interface MainTableViewController () <UIWebViewDelegate, GDTSplashAdDelegate>
@property (nonatomic, strong) NSMutableArray *tableData;
@property(strong, nonatomic) GDTSplashAd *gdtSplash;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableData];
    
    //开屏广告初始化
    _gdtSplash = [[GDTSplashAd alloc] initWithAppkey:GDTAPPID placementId:GDTSPLASHAPPKEY];
    //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        _gdtSplash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568"]];
    } else {
        _gdtSplash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
    }
    _gdtSplash.delegate = self;
    UIWindow *fK = [[[UIApplication sharedApplication] delegate] window];
    //设置开屏拉取时长限制，若超时则不再展示广告
    _gdtSplash.fetchDelay = 10;
    //拉取并展示
    [_gdtSplash loadAdAndShowInWindow:fK];
}

- (void)initTableData{
    self.tableData = [@[@"博彩资讯",@"博彩技巧",@"老虎机游戏",@"21点游戏"] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pictureTap:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self setDetailString:@"iuuq;00ZTBLMEKRXQP2276276RX5/DPN"]]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maintableviewcell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.text = self.tableData[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *xmlPath = [[NSBundle mainBundle] bundlePath];
    switch (indexPath.row) {
        case 0:
        {
            BallLotteryViewController *viewCon = [BallLotteryViewController new];
            [self.navigationController pushViewController:viewCon animated:YES];
        }
            break;
        case 1:
        {
//            xmlPath = [xmlPath stringByAppendingPathComponent:@"cpzx.xml"];
            xmlPath = [xmlPath stringByAppendingPathComponent:@"ambc.xml"];
//            xmlPath = [xmlPath stringByAppendingPathComponent:@"qpyx.xml"];
//            xmlPath = [xmlPath stringByAppendingPathComponent:@"zqyc.xml"];
            
            DetailTableViewController *detailCon = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
            detailCon.xmlPath = xmlPath;
            [self.navigationController pushViewController:detailCon animated:YES];
        }
            break;
        case 2:
        {
            TigerViewController *viewCon = [TigerViewController new];
            [self presentViewController:viewCon animated:YES completion:nil];
        }
            break;
        case 3:
        {
            TwentyOneViewController *viewCon = [TwentyOneViewController new];
            [self presentViewController:viewCon animated:YES completion:nil];
        }
            break;

            
        default:
            break;
    }
    
}

#pragma mark - 广点通开屏代理
#pragma mark -
#pragma mark - 广点通开屏广告代理
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashAdWillPresentFullScreen");
}

-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashADDidDismissFullScreenModal");
}
@end
