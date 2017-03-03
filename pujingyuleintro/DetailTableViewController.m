//
//  DetailTableViewController.m
//  pujingyuleintro
//
//  Created by JFChen on 17/2/26.
//  Copyright © 2017年 JFChen. All rights reserved.
//

#import "DetailTableViewController.h"
#import "XMLDataAnalysis.h"
#import "DetailViewController.h"

@interface DetailTableViewController ()
@end

@implementation DetailTableViewController{
    XMLDataAnalysis *_xmlDataAnaly;
    NSDictionary *_xmlDataDic;
    NSArray *_xmlAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _xmlDataAnaly = [XMLDataAnalysis new];
    [_xmlDataAnaly analysisXMLData:_xmlPath completeBlock:^(NSDictionary *completeDic) {
        _xmlDataDic = completeDic;
        _xmlAry = [_xmlDataDic allKeys];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_xmlAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailtableviewcell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _xmlAry[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailTab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailTab.title = _xmlAry[indexPath.row];
    NSString* article = _xmlDataDic[_xmlAry[indexPath.row]];
    NSString* subString = [article substringFromIndex:article.length - 10];
    article = [article stringByReplacingOccurrencesOfString:subString withString:@"\n    "];
    detailTab.article = [@"    " stringByAppendingString:article];
    [self.navigationController pushViewController:detailTab animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
