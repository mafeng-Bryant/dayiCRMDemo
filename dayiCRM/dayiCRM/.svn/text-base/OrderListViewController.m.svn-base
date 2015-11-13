//
//  OrderListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWHomeCache.h"
#import "DropDownListView.h"
#import "RevenueViewController.h"
#import "OrderStoreDetailViewController.h"
#import "TakeOrderViewController.h"

@interface OrderListViewController ()
@property (nonatomic,retain)UIView *head_view;
@property (nonatomic,retain)UIImageView *im_point;
@property (nonatomic,retain)RevenueViewController *revenueViewCtrl;
@property (nonatomic,retain)DropDownListView * dropDownView;
@end

@implementation OrderListViewController
@synthesize type;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(type == 1){
        self.title = @"门店订单";
    }
    else{
        self.title = @"线上订单";
    }
    UIBarButtonItem *backBtn;
    UIBarButtonItem *btn_list;
    if (IOS7)
    {
        backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        btn_list = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_member"] style:UIBarButtonItemStylePlain target:self action:@selector(btn_list_click:)];
         self.navigationItem.backBarButtonItem = backBtn;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"add_member"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_list_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_list = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
//    self.navigationItem.rightBarButtonItem = btn_list;

    if(![[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
    {
        [self initHeadView];
    }
    
//    [self setUpDropDownList];
    
    //bottom refresh header
	CGRect bottom_rect = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor clearColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
	[self.tableView addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;

    buffer = [NSMutableArray array];
    pageIndex = 1;

    NSArray *arr = [RWHomeCache readFromFile:@"orderList"];
	if ([arr count])
	{
		[buffer addObjectsFromArray:arr];
		[self.tableView reloadData];
	}

    [self loadData];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"storeDidChange" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"orderDidChange" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dropDownView hideExtendedChooseView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (0 == [buffer count]) {
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
        cell.textLabel.text = @"无数据";
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    NSString *CellIdentifier = @"OrderListCell";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[buffer objectAtIndex:indexPath.section] ];
    [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (OrderListCell *)uc.view;
        [cell setContent:dic];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count]) {
        return 142;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        return;
    }
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    if (1 == type) {
        OrderStoreDetailViewController *ctrl = [[OrderStoreDetailViewController alloc] initWithNibName:@"OrderStoreDetailViewController" bundle:nil];
        ctrl.oid = [dic objectForKey:@"id"];
        ctrl.type = is_confirmed;
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        return;
    }
    
    OrderDetailViewController *ctrl = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    ctrl.oid = [dic objectForKey:@"id"];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
	else if ([buffer count] == indexPath.section+1)
	{
		if (tableView.contentSize.height > tableView.bounds.size.height && pageCount > pageIndex-1)
		{
			CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
			refreshHeaderView_bottom.frame = bottom_rect;
			refreshHeaderView_bottom.hidden = NO;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        if(![[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
            return 58;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        if(![[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
        {
            return  self.head_view;
        }
 
        return  self.head_view;
    }
    return nil;
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	if (!scrollView.isDragging)
	{
		return;
	}
    
	if (refreshHeaderView_bottom.state == EGOOPullRefreshPulling &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 65.0f && pageCount > pageIndex-1)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	}
	else if (refreshHeaderView_bottom.state == EGOOPullRefreshNormalUP &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f && pageCount > pageIndex-1)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshPulling];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentSize.height > scrollView.bounds.size.height &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f
        && pageCount > pageIndex-1)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [self fetchOld];
	}
}

- (void) updateTableViewBefore
{
	[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	refreshHeaderView_bottom.hidden = YES;
	
	self.tableView.contentInset = UIEdgeInsetsZero;
	[self.tableView reloadData];
}


#pragma mark -

- (void)reloadData
{
    [buffer removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}

- (void)loadData
{
    if ([buffer count] == 0)
        [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url;
    if(![[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
    {
        full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, is_confirmed? CONFIRMEDORDER_LIST_URL:ORDER_LIST_URL];
    }
    else{
        full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,CONFIRMEDORDER_LIST_URL];
    }
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:@"1" forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
    [req setParam:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
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
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
        
    //login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        [buffer removeAllObjects];
        [self.tableView reloadData];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [buffer removeAllObjects];
        [RWHomeCache writeToFile:buffer withName:@"orderList"];
        [self.tableView reloadData];
        return;
    }
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    if (!is_confirmed)
        [RWHomeCache writeToFile:buffer withName:@"orderList"];
    pageCount = [[data objectForKey:@"pageCount"]integerValue];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
    [self.tableView reloadData];
}

- (void) fetchOld
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, is_confirmed? CONFIRMEDORDER_LIST_URL:ORDER_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
    [req setParam:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFetchOld:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];

}

- (void) onFetchOld: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [SVProgressHUD dismissWithError:@"暂无更多数据!" afterDelay:1.5f];
        return;
    }
    [buffer addObjectsFromArray:arr];
    pageCount = [[data objectForKey:@"pageCount"]integerValue];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
    [self updateTableViewBefore];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)initHeadView
{
    self.head_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 54.0f)];
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    im.image = [UIImage imageNamed:@"order_select_bg"];
    
    im.userInteractionEnabled = YES;
    
    self.im_point = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 7.0f, 30.0f, 30.0f)];
    self.im_point.image = [UIImage imageNamed:@"point_green"];
    [im addSubview:self.im_point];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    if(type == 1){
        [btn1 setTitle:@"未结账" forState:UIControlStateNormal];
    }
    else{
        [btn1 setTitle:@"未确认" forState:UIControlStateNormal];
    }
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn_order_select_click:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(0.0f, 0.0f, 160.0f, 44.0f);
    btn1.tag = 1;
    [im addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    if(type == 1){
        [btn2 setTitle:@"已结账" forState:UIControlStateNormal];
    }
    else{
        [btn2 setTitle:@"已确认" forState:UIControlStateNormal];
    }
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn_order_select_click:) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(160.0f, 0.0f, 160.0f, 44.0f);
    btn2.tag = 2;
    [im addSubview:btn2];

    [self.head_view addSubview:im];
}

- (void)btn_order_select_click:(id)sender
{
    if ([sender tag] == 1) {
        is_confirmed = NO;
        self.im_point.frame = CGRectMake(30.0f, 7.0f, 30.0f, 30.0f);
    }
    else if ([sender tag] == 2){
        is_confirmed = YES;
        self.im_point.frame = CGRectMake(190.0f, 7.0f, 30.0f, 30.0f);
    }
    [buffer removeAllObjects];
    [self loadData];
}

- (void)setUpDropDownList
{
    if (self.dropDownView)
        self.dropDownView = nil;
    
    self.dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(20,5,140, 40) dataSource:self delegate:self];
    self.dropDownView.mSuperView = self.view;
    self.dropDownView.backgroundColor = dayiColor;
    self.navigationItem.titleView = self.dropDownView;
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    if (2 == index) {
        if (self.revenueViewCtrl == nil) {
            [self showRevenueView];
        }
    }
    else
    {
        [self dismisRevenueView];
        if (0 == index) {
            type = 2;
            [btn1 setTitle:@"未确认" forState:UIControlStateNormal];
            [btn2 setTitle:@"已确认" forState:UIControlStateNormal];
        }
        else if (1 == index){
            type = 1;
            [btn1 setTitle:@"未结账" forState:UIControlStateNormal];
            [btn2 setTitle:@"已结账" forState:UIControlStateNormal];

        }
        [self loadData];
    }
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    NSString *name = nil;
    if (0 == index) {
        name = @"线上订单";
    }
    else if (1 == index){
        name = @"门店订单";
    }
    else if (2 == index){
        name = @"收入";
    }
    return name;
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

- (void)showRevenueView
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.tableView.scrollEnabled = NO;
    self.revenueViewCtrl = [[RevenueViewController alloc] init];
    self.revenueViewCtrl.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view addSubview:self.revenueViewCtrl.view];
}

- (void)dismisRevenueView
{
    self.tableView.scrollEnabled = YES;

    [self.revenueViewCtrl.view removeFromSuperview];
    self.revenueViewCtrl = nil;
}

- (void)btn_list_click:(id)sender
{
    TakeOrderViewController *ctrl = [[TakeOrderViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

}

@end
