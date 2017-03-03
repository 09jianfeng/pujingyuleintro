//
//  MainTableViewController.m
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "MainTableViewController.h"
#import "DetailTableViewController.h"

@interface MainTableViewController ()
@property (nonatomic, strong) NSArray *tableData;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableData];
}

- (void)initTableData{
    self.tableData = @[@"博彩资讯",@"彩票资讯",@"棋牌游戏技巧",@"足球预测"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pictureTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pujing.com"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            xmlPath = [xmlPath stringByAppendingPathComponent:@"ambc.xml"];
            break;
        case 1:
            xmlPath = [xmlPath stringByAppendingPathComponent:@"cpzx.xml"];
            break;
        case 2:
            xmlPath = [xmlPath stringByAppendingPathComponent:@"qpyx.xml"];
            break;
        case 3:
            xmlPath = [xmlPath stringByAppendingPathComponent:@"zqyc.xml"];
            break;
            
        default:
            break;
    }
    
    DetailTableViewController *detailCon = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
    detailCon.xmlPath = xmlPath;
    [self.navigationController pushViewController:detailCon animated:YES];
}

@end
