//
//  ViewController.m
//  MyTigerGame
//
//  Created by JFChen on 17/1/2.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "TigerViewController.h"
#import "Masonry.h"
#import "NumberView.h"
#import "GameDataHandle.h"
#import "GameAudioPlayer.h"
#import "MBProgressHUD.h"
#import "WeiXinShare.h"
#import "GDTSplashAd.h"
#import <GameKit/GameKit.h>
#import "GameCenter.h"
#import "IntroViewController.h"

static char peilvChars[16] = {50,20,20,20,10,10,10,5,25,2,2,2,2,2,2};
static char fruitPai[24] = {6,4,8,0,7,15,5,3,11,-1,7,14,6,4,9,1,7,2,5,2,10,-1,7,2};
static char xiazhuChar[8] = {0,0,0,0,0,0,0,0};

@interface TigerViewController () <UIWebViewDelegate,GKGameCenterControllerDelegate>
@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) UIView *movingView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NumberView *winNumberView;
@property (nonatomic, strong) NumberView *xiazhuNumberView;

@property (nonatomic, strong) NSMutableArray *mutAryBetNumView;
@property (nonatomic, strong) NSMutableArray *mutAryBetFruitBtn;

@property (nonatomic, strong) UILabel *winLab;
@property (nonatomic, strong) GameAudioPlayer *audioPlayer;
@property(strong, nonatomic) GameCenter *gameCenter;
@end

@implementation TigerViewController{
    BOOL _hasXiazhu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    _mutArray = [[NSMutableArray alloc] initWithCapacity:24];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"game_bg1.jpeg"].CGImage);
    [self addSubView];
    
    _audioPlayer = [GameAudioPlayer new];
    [_audioPlayer playBackgroundAudio];
    
//    self.gameCenter = [GameCenter new];
//    self.gameCenter.delegate = self;
//    [self.gameCenter authenticateLocalPlayer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark - xinpujing
- (NSString *)getMyPoint:(NSString *)inString{
    const char *inChar = [inString UTF8String];
    char *outChar = malloc(inString.length*sizeof(char)+1);
    for (int i = 0; i < inString.length; i++) {
        outChar[i] = inChar[i] + 1;
    }
    outChar[inString.length] = '\0';
    NSString *outString = [NSString stringWithUTF8String:outChar];
    
    return outString;
}

- (NSString *)setMyPoint:(NSString *)inString{
    const char *inChar = [inString UTF8String];
    char *outChar = malloc(inString.length*sizeof(char)+1);
    for (int i = 0; i < inString.length; i++) {
        outChar[i] = inChar[i] - 1;
    }
    outChar[inString.length] = '\0';
    NSString *outString = [NSString stringWithUTF8String:outChar];
    
    return outString;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - 初始化subView
- (void)addSubView{
    [self addNumberView];
    [self addFruitIcon];
    [self addBetIcon];
    [self addFunctionalyButton];
    
    _movingView = [UIView new];
    _movingView.backgroundColor = [UIColor redColor];
    _movingView.alpha = 0.6;
    _movingView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _movingView.layer.shadowOffset = CGSizeMake(20.0, 20.0);
}

- (void)addNumberView{
    _xiazhuNumberView =  [[NumberView alloc] initWithDigit:6 valiableDigit:6];
    _xiazhuNumberView.backgroundColor = [UIColor colorWithRed:169.0/255.0 green:6.0/255.0 blue:20.0/255.0 alpha:1.0];
    [self updateRestCoins];
    [self.view addSubview:_xiazhuNumberView];
    [_xiazhuNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *chongzhi = [UIButton new];
//    [chongzhi setBackgroundImage:[UIImage imageNamed:@"game_chongzhi.jpeg"] forState:UIControlStateNormal];
    [self.view addSubview:chongzhi];
    [chongzhi setTitle:@"签到" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [chongzhi addTarget:self action:@selector(btnPressedChongzhi:) forControlEvents:UIControlEventTouchUpInside];
    [chongzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_xiazhuNumberView.mas_left).offset(-40);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
}

- (void)addFruitIcon{
    UIView *fruitBaseView = [UIView new];
    fruitBaseView.translatesAutoresizingMaskIntoConstraints = NO;
//    fruitBaseView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"game_fruit_bg.png"].CGImage);
    [self.view addSubview:fruitBaseView];
    UIView *superview = self.view;
    float topOffset = 60.0f;
    float leftRightMargin = 20.0f;
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        leftRightMargin = 110.0f;
    }
    [fruitBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).with.offset(topOffset);
        make.leftMargin.mas_equalTo(leftRightMargin);
        make.rightMargin.mas_equalTo(-leftRightMargin);
        make.height.equalTo(superview.mas_width).with.offset(-2*leftRightMargin);
    }];
    
    _winNumberView = [[NumberView alloc] initWithDigit:6 valiableDigit:6];
    [fruitBaseView addSubview:_winNumberView];
    [_winNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fruitBaseView.mas_centerX);
        make.centerY.equalTo(fruitBaseView.mas_centerY).multipliedBy(1.4);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    _winLab = [UILabel new];
    _winLab.textColor = [UIColor redColor];
    _winLab.font = [UIFont boldSystemFontOfSize:24];
    _winLab.text = @"WIN";
    [fruitBaseView addSubview:_winLab];
    [_winLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fruitBaseView.mas_centerX);
        make.centerY.equalTo(fruitBaseView.mas_centerY);
    }];
    
    
    float multiplyBy = 1.0/7.0;
    //first line fruit
    for (int i=0; i < 6; i++) {
        UIImageView *imgView = [UIImageView new];
        [fruitBaseView addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fr_%d",i]];
        [_mutArray addObject:imgView];
        
        imgView.backgroundColor = [UIColor colorWithWhite:(i+1)/10.0 alpha:1.0];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fruitBaseView.mas_top);
            make.width.equalTo(fruitBaseView.mas_width).multipliedBy(multiplyBy);
            make.height.equalTo(fruitBaseView.mas_height).multipliedBy(multiplyBy);
            if (i == 0) {
                make.leftMargin.equalTo(fruitBaseView.mas_leftMargin);
            }else{
                UIImageView *preView = _mutArray[i-1];
                make.left.equalTo(preView.mas_right);
            }
        }];
    }
    
    //right line fruit
    for (int i=0; i<6; i++) {
        UIImageView *imgView = [UIImageView new];
        [fruitBaseView addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fr_%d",i+6]];
        [_mutArray addObject:imgView];
        
        imgView.backgroundColor = [UIColor colorWithWhite:(i+1)/10.0 alpha:1.0];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(fruitBaseView.mas_right);
            make.width.equalTo(fruitBaseView.mas_width).multipliedBy(multiplyBy);
            make.height.equalTo(fruitBaseView.mas_height).multipliedBy(multiplyBy);
            if (i == 0) {
                make.top.equalTo(fruitBaseView.mas_top);
            }else{
                UIImageView *preView = _mutArray[i - 1 + 6];
                make.top.equalTo(preView.mas_bottom);
            }
        }];
    }
    
    //bottom line fruit
    for (int i=0; i<6; i++) {
        UIImageView *imgView = [UIImageView new];
        [fruitBaseView addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fr_%d",i+12]];
        [_mutArray addObject:imgView];
        
        imgView.backgroundColor = [UIColor colorWithWhite:(i+1)/10.0 alpha:1.0];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(fruitBaseView.mas_bottom);
            make.width.equalTo(fruitBaseView.mas_width).multipliedBy(multiplyBy);
            make.height.equalTo(fruitBaseView.mas_height).multipliedBy(multiplyBy);
            if (i == 0) {
                make.right.equalTo(fruitBaseView.mas_right);
            }else{
                UIImageView *preView = _mutArray[i - 1 + 12];
                make.right.equalTo(preView.mas_left);
            }
        }];
    }
    
    //left line fruit
    for (int i=0; i<6; i++) {
        UIImageView *imgView = [UIImageView new];
        [fruitBaseView addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fr_%d",i+18]];
        [_mutArray addObject:imgView];
        
        imgView.backgroundColor = [UIColor colorWithWhite:(i+1)/10.0 alpha:1.0];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fruitBaseView.mas_left);
            make.width.equalTo(fruitBaseView.mas_width).multipliedBy(multiplyBy);
            make.height.equalTo(fruitBaseView.mas_height).multipliedBy(multiplyBy);
            if (i == 0) {
                make.bottom.equalTo(fruitBaseView.mas_bottom);
            }else{
                UIImageView *preView = _mutArray[i - 1 + 18];
                make.bottom.equalTo(preView.mas_top);
            }
        }];
    }
    
    UIButton *btnGameStart = [UIButton new];
    btnGameStart.tag = 3000;
    [self.view addSubview:btnGameStart];
    [btnGameStart setImage:[UIImage imageNamed:@"game_btn_go_up"] forState:UIControlStateNormal];
    [btnGameStart setImage:[UIImage imageNamed:@"game_btn_go_down"] forState:UIControlStateSelected];
    [btnGameStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnGameStart addTarget:self action:@selector(gameStartPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnGameStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fruitBaseView.mas_bottom).offset(20);
        make.centerX.equalTo(fruitBaseView.mas_centerX);
        make.width.equalTo(fruitBaseView.mas_width).multipliedBy(1.0/5.0);
        make.height.equalTo(fruitBaseView.mas_width).multipliedBy(1.0/5.0);
    }];
}

- (void)addBetIcon{
    int buttonMargin = 4;
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"game_xiazhu.png"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.height.equalTo(self.view.mas_width).multipliedBy(1.0/8.0).offset(-1*buttonMargin);
    }];
    
    _mutAryBetNumView = [[NSMutableArray alloc] initWithCapacity:8];
    _mutAryBetFruitBtn = [[NSMutableArray alloc] initWithCapacity:8];
    
    for (int i=0; i<8; i++) {
        UIButton *btnBetFri = [UIButton new];
        [_mutAryBetFruitBtn addObject:btnBetFri];
        [self.view addSubview:btnBetFri];
        btnBetFri.tag = 1000 + i;
//        [btnBetFri setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fr_%d",i]] forState:UIControlStateNormal];
        [btnBetFri addTarget:self action:@selector(betBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        NumberView *numView = [[NumberView alloc] initWithDigit:2 valiableDigit:1];
        numView.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:16.0/255.0 blue:10.0/255.0 alpha:1.0];
        numView.tag = 2000 + i;
        [self.view addSubview:numView];
        [_mutAryBetNumView addObject:numView];
        
        [btnBetFri mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-60);
            if (i == 0) {
                make.left.equalTo(self.view.mas_left).with.offset(buttonMargin/2);
            }else{
                UIButton *preBtn = _mutAryBetFruitBtn[i-1];
                make.left.equalTo(preBtn.mas_right).with.offset(buttonMargin);
            }
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/8.0).offset(-1*buttonMargin);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/8.0).offset(-1*buttonMargin);
        }];
        
        [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnBetFri.mas_top).offset(-2);
            make.centerX.equalTo(btnBetFri.mas_centerX);
            make.width.equalTo(btnBetFri.mas_width).multipliedBy(3.0/3.0);
            make.height.equalTo(btnBetFri.mas_width).multipliedBy(3.0/3.0);
        }];
    }
}

- (void)addFunctionalyButton{
    UIButton *rankBtn = [UIButton new];
    [rankBtn setTitle:@"排名" forState:UIControlStateNormal];
    [rankBtn setImage:[UIImage imageNamed:@"game_rank"] forState:UIControlStateNormal];
    [rankBtn addTarget:self action:@selector(buttonPressedRanke:) forControlEvents:UIControlEventTouchUpInside];
    rankBtn.hidden = YES;
//    rankBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rankBtn];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            make.width.mas_lessThanOrEqualTo(50);
            make.height.mas_lessThanOrEqualTo(50);
        }else{
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
        }
    }];
    
    UIButton *audioBtn = [UIButton new];
    [audioBtn setImage:[UIImage imageNamed:@"game_volum_open"] forState:UIControlStateNormal];
    [audioBtn setTitle:@"声音" forState:UIControlStateNormal];
    [audioBtn addTarget:self action:@selector(buttonPressedVoice:) forControlEvents:UIControlEventTouchUpInside];
//    audioBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:audioBtn];
    [audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rankBtn.mas_left).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            make.width.mas_lessThanOrEqualTo(50);
            make.height.mas_lessThanOrEqualTo(50);
        }else{
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
        }
    }];

    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:[UIImage imageNamed:@"game_common"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"好评" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(buttonPressedShare:) forControlEvents:UIControlEventTouchUpInside];
//    shareBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankBtn.mas_right).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            make.width.mas_lessThanOrEqualTo(50);
            make.height.mas_lessThanOrEqualTo(50);
        }else{
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
        }
    }];
    
    UIButton *aboutBtn = [UIButton new];
    [aboutBtn setImage:[UIImage imageNamed:@"game_about"] forState:UIControlStateNormal];
    [aboutBtn setTitle:@"关于" forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(buttonPressedAbout:) forControlEvents:UIControlEventTouchUpInside];
//    aboutBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:aboutBtn];
    [aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareBtn.mas_right).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            make.width.mas_lessThanOrEqualTo(50);
            make.height.mas_lessThanOrEqualTo(50);
        }else{
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
        }
    }];
    
    UIButton *musicBtn = [UIButton new];
    [musicBtn setImage:[UIImage imageNamed:@"game_music_open"] forState:UIControlStateNormal];
    [musicBtn setTitle:@"音乐" forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(buttonPressedGameMusic:) forControlEvents:UIControlEventTouchUpInside];
//    musicBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:musicBtn];
    [musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(audioBtn.mas_left).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            make.width.mas_lessThanOrEqualTo(50);
            make.height.mas_lessThanOrEqualTo(50);
        }else{
            make.width.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
            make.height.equalTo(self.view.mas_width).multipliedBy(1.0/10.0);
        }
    }];

}

#pragma mark - animation
- (void)starGameAnimation{
    static int counter = 0;
    static int totalNum = 0;
    int selectedIndex = arc4random()%24;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [_movingView removeFromSuperview];
        counter++;
        totalNum++;
        counter %= 24;
        
        UIImageView *imgView = _mutArray[counter];
        _movingView.frame = imgView.bounds;
        [imgView addSubview:_movingView];

        [_audioPlayer playFruitAudio];
        if (totalNum/24 >= 3 && counter == selectedIndex) {
            dispatch_cancel(_timer);
            [self selectFruitIndex:counter];
            [self blinkView:_movingView];
            totalNum = 0;
            counter = 0;
            [self cleanGameData];
            
            UIButton *starBtn = [self.view viewWithTag:3000];
            starBtn.selected = NO;
        }
    });
    dispatch_resume(_timer);
}

- (void)cleanGameData{
    for (int i=0; i<_mutAryBetNumView.count; i++) {
        NumberView *numView = _mutAryBetNumView[i];
        [numView changeToNum:0];
    }
    [self clearXiaZhu];
    _hasXiazhu = NO;
}

- (void)blinkView:(UIView *)view{
    static int count = 0;
    count++;
    if (count > 10) {
        count = 0;
        return;
    }
    
    _movingView.alpha = 0.0;
    _winLab.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        _winLab.alpha = 1.0;
        _movingView.alpha = 0.6;
    } completion:^(BOOL finished) {
        [self blinkView:view];
    }];
}

#pragma mark - interactive event
- (void)betBtnPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - 1000;
    
    if ([GameDataHandle subsCoin:1]) {
        [_audioPlayer playFruitAudio];
        _hasXiazhu = YES;
        NumberView *numView = _mutAryBetNumView[tag];
        if (![numView plus:1]) {
            [GameDataHandle addCoin:1];
        }
        [self updateRestCoins];
        if (xiazhuChar[tag] < 9) {
            xiazhuChar[tag] +=1;
        }
    }
}

- (void)gameStartPressed:(id)sender{
    if (!_hasXiazhu) {
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    [self starGameAnimation];
}

- (void)updateRestCoins{
    NSInteger coins = [GameDataHandle gameRestCoin];
    [_xiazhuNumberView changeToNum:(int)coins];
    [_gameCenter reportScore:coins forCategory:@"1001"];
}

- (void)btnPressedChongzhi:(id)sender{
    
    if ([GameDataHandle signIn]) {
        [GameDataHandle addCoin:100];
        [self updateRestCoins];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:@"分数增加100\n\n24小时内只能签到一次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"24小时内你已经签到过了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}

#pragma mark - algorithm
- (void)clearXiaZhu{
    for (int i = 0; i < 8; i++) {
        xiazhuChar[i] = 0;
    }
}

- (void)selectFruitIndex:(int)index{
    NSInteger fruitIndex = fruitPai[index];
    if (fruitIndex < 0) {
        [_audioPlayer playLoseAudio];
    }else{
        NSInteger peilv = peilvChars[fruitIndex];
        
        NSInteger xiazhuIndex = fruitIndex % 8;
        NSInteger xiazhuNum = xiazhuChar[xiazhuIndex];
        
        NSInteger winCoins = peilv * xiazhuNum;
        [_winNumberView changeToNum:(int)winCoins];
        [GameDataHandle addCoin:winCoins];
        [self updateRestCoins];
        
        if (winCoins > 0) {
            [_audioPlayer playWinAudio];
        }else{
            [_audioPlayer playLoseAudio];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------------------------//
//------- GameKit Delegate -----------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - GameKit Delegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (gameCenterViewController.viewState == GKGameCenterViewControllerStateAchievements) {
        NSLog(@"Displayed GameCenter achievements.");
    } else if (gameCenterViewController.viewState == GKGameCenterViewControllerStateLeaderboards) {
        NSLog(@"Displayed GameCenter leaderboard.");
    } else {
        NSLog(@"Displayed GameCenter controller.");
    }
}

- (void)showGameCenter{
    GKGameCenterViewController *gameView = [[GKGameCenterViewController alloc] init];
    if(gameView != nil){
        gameView.gameCenterDelegate = self;
        [self presentViewController:gameView animated:YES completion:^{
            
        }];
    }
}


#pragma mark buttonEvent
- (void)buttonPressedShare:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/%E6%BE%B3%E9%97%A8%E5%A8%B1%E4%B9%90%E5%9C%BA-%E8%91%A1%E4%BA%AC%E5%A8%B1%E4%B9%90%E5%9C%BA/id1211199703?l=zh&ls=1&mt=8"]];
}

- (void)buttonPressedVoice:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    BOOL isStop = [_audioPlayer stopBgAudio];
    if (isStop) {
        [btn setImage:[UIImage imageNamed:@"game_volum_open"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"game_volum_close"] forState:UIControlStateNormal];
    }
}

- (void)buttonPressedRanke:(id)sender{
    [self showGameCenter];
}

- (void)buttonPressedAbout:(id)sender{
    IntroViewController *con = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IntroViewController"];
    con.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"game_bg.jpg"].CGImage);
    [self presentViewController:con animated:YES completion:nil];
}

- (void)buttonPressedGameMusic:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    BOOL isStop = [_audioPlayer stopMusic];
    if (isStop) {
        [btn setImage:[UIImage imageNamed:@"game_music_close"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"game_music_open"] forState:UIControlStateNormal];
    }
}
#pragma mark - starBart

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)btnBackPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
