//
//  StockCheckReportViewController.m
//  dayiCRM
//
//  Created by Fang on 14/10/23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockCheckReportViewController.h"
#import "StockCheckReportViewCell.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "StockCheckReportViewCell.h"
#import "ProductListViewController.h"

@interface StockCheckReportViewController ()

@end

@implementation StockCheckReportViewController
@synthesize reportId,dataDict;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"盘点报告";
    
    buffer = [NSMutableArray array];
    
    UIBarButtonItem *btn_add;
    UIBarButtonItem *btn_cancel;
    if (IOS7)
    {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        btn_add = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"img76"] style:UIBarButtonItemStylePlain target:self action:@selector(btn_edit_click:)];
    }
    else
    {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn1 addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"img76"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_edit_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_add = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    btn_del = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_del setImage:[UIImage imageNamed:@"img75"] forState:UIControlStateNormal];
    [btn_del setFrame:CGRectMake(230.0f, 7.0f, 30, 30)];
    [btn_del addTarget:self action:@selector(btn_del_click:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = btn_add;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"stockCheckDidChange" object:nil];

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:btn_del];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [btn_del removeFromSuperview];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([buffer count] == 0) {
        static NSString *cell_id = @"empty_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = @"加载中...";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = font;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    NSString *CellIdentifier = @"StockCheckReportViewCell";
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    
    StockCheckReportViewCell *cell = (StockCheckReportViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        cell = (StockCheckReportViewCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count]) {
        return 120;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 64;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 != section) {
        return nil;
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    UIView *bg =[[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 50)];
    bg.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    lb_title.font = [UIFont systemFontOfSize:15];
    lb_title.text = [dataDict objectForKey:@"name"];
    
    [bg addSubview:lb_title];
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM"];
    NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"createTime"] doubleValue]/1000]];

    UILabel *lb_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
    lb_subtitle.font = [UIFont systemFontOfSize:13];
    lb_subtitle.textColor = [UIColor lightGrayColor];
    lb_subtitle.text = [NSString stringWithFormat:@"经办人:%@ %@",[dataDict objectForKey:@"userName"],start_date ];
    [bg addSubview:lb_subtitle];
    [v addSubview:bg];
    return v;
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_edit_click:(id)sender
{
    ProductListViewController *ctrl = [[ProductListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.reportId = reportId;
    ctrl.isStockCheck = YES;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void)btn_del_click:(id)sender
{
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"报告删除后将无法恢复" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];

}

#pragma mark loadData

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, REPORT_DETAIL_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:reportId forKey:@"reportId"];
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [self.view hideToastActivity];
    RRLoader *loader = (RRLoader *)[notify object];
    
    NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",json);
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
    NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"dataArray"];
    if ([arr count] == 0) {
        [SVProgressHUD showSuccessWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    
    [self.tableView reloadData];
}


- (void)delReport
{
    [SVProgressHUD showWithStatus:@"删除报告中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_REPORT_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:reportId forKey:@"reportId"];
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onDelReport:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onDelReport: (NSNotification *)notify
{
    [self.view hideToastActivity];
    RRLoader *loader = (RRLoader *)[notify object];
    
    NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",json);
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stockCheckDidChange" object:nil];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    
}

- (void)didClickOnDestructiveButton
{
    [self delReport];
}

- (void)didClickOnCancelButton
{
    
}

@end
