//
//  StockCheckListViewController.m
//  dayiCRM
//
//  Created by Fang on 14/10/21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockCheckListViewController.h"
#import "ProductListViewController.h"
#import "StockCheckReportViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface StockCheckListViewController ()

@end

@implementation StockCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"库存盘点";
    UIBarButtonItem *backBtn;
    UIBarButtonItem *btn_add;
    UIBarButtonItem *btn_cancel;

    if (IOS7)
    {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        btn_add = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_member"] style:UIBarButtonItemStylePlain target:self action:@selector(btn_add_click:)];
        self.navigationItem.backBarButtonItem = backBtn;
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
        [btn setImage:[UIImage imageNamed:@"add_member"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_add = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    self.navigationItem.rightBarButtonItem = btn_add;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    buffer = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"stockCheckDidChange" object:nil];

    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([buffer count] == 0) {
        return 1;
    }
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
        cell.textLabel.text = @"暂无盘点记录,赶紧去盘点吧!";
        cell.textLabel.font = font;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    
    static NSString *cell_id = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id];
    }
    
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    cell.textLabel.text = [dic objectForKey:@"name"];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM"];
    NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"createTime"] doubleValue]/1000]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"经办人:%@ %@",[dic objectForKey:@"userName"],start_date ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([buffer count] == 0) {
        return;
    }
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    
    StockCheckReportViewController *ctrl = [[StockCheckReportViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.reportId = [dic objectForKey:@"reportId"];
    ctrl.dataDict = dic;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_add_click:(id)sender
{
    ProductListViewController *ctrl = [[ProductListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.isStockCheck = YES;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark loadData

- (void)loadData
{
    [buffer removeAllObjects];
    [self.tableView reloadData];

    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, INVENTORY_REPORT_LIST];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
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
    
    NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"jsonArray"];
    if ([arr count] == 0) {
        [SVProgressHUD showSuccessWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
}


@end
