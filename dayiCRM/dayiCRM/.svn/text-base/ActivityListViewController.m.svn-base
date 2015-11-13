//
//  ActivityListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-13.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ActivityListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "ActivityListViewCell.h"
#import "ActivityDetailViewController.h"
#import "EditActivityViewController.h"

@interface ActivityListViewController ()

@end

@implementation ActivityListViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (delegate) {
        self.title = @"选择活动";
    }
    else{
         self.title = @"活动中心";
    }
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_add;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_add = [[UIBarButtonItem alloc] initWithTitle:@"新增"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_add_click:)];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
        [add setTitle:@"新增" forState:UIControlStateNormal];
        [add setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [add addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_add = [[UIBarButtonItem alloc] initWithCustomView:add];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    if (!delegate) {
        self.navigationItem.rightBarButtonItem = btn_add;
    }
    buffer = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"activityDidUpdate" object:nil];

    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([buffer count] == 0) {
        return 1;
    }
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        static NSString *cell_id = @"empty_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = @"暂无活动,\n立即去创建新活动吧!";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = font;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    NSString *CellIdentifier = @"ActivityListViewCell";
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    
    ActivityListViewCell *cell = (ActivityListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        cell = (ActivityListViewCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count]) {
        return 216.0f;
    }
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    
    if (delegate &&[delegate respondsToSelector:@selector(activityListViewControllerDidSelected:)]) {
        [delegate activityListViewControllerDidSelected:dic];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ActivityDetailViewController *ctrl = [[ActivityDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.aid = [dic objectForKey:@"entityId"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_add_click:(id)sender
{
    EditActivityViewController  *ctrl = [[EditActivityViewController alloc] initWithNibName:@"EditActivityViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark loadData

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, ACTIVITY_LIST_URL];
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
    
    NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"entityList"];
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
