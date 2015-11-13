//
//  ChannelManagerListViewController.m
//  dayiCRM
//
//  Created by Leo on 14/11/3.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ChannelManagerListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "ChannelManagerListViewCell.h"
#import "ChannelManagerDetailViewController.h"
#import "DropDownListView.h"
#import "AuthListViewCell.h"
#import "AuthDetailViewController.h"

@interface ChannelManagerListViewController ()<DropDownChooseDelegate,DropDownChooseDataSource>
@property (nonatomic,retain)UIView *head_view;
@property (nonatomic,retain)UIImageView *im_point;
@property (nonatomic,retain)DropDownListView * dropDownView;

@end

@implementation ChannelManagerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"渠道管理";
	buffer = [NSMutableArray array];

	UIBarButtonItem *btn_cancel;
	if (IOS7) {
		btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
	}
	else
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
		[btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
		[btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
		btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];

		self.tableView.separatorColor = [UIColor clearColor];
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.navigationItem.hidesBackButton = YES;
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
	}
	self.navigationItem.leftBarButtonItem = btn_cancel;

	CGRect bottom_rect = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor clearColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
	[self.tableView addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;
	pageIndex = 1;
    type = 0;
	auditState = @"N";
    [self setUpDropDownList];
	[self initHeadView];
	[self loadData];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"ChannelManagerDidChange" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dropDownView hideExtendedChooseView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (0 == [buffer count]) {
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
		NSString *cell_id = @"empty_cell";

		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}

		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.text = @"无数据";
		cell.textLabel.font = font;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		return cell;
	}

    if (type) {
        NSString *CellIdentifier = @"AuthListViewCell";
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[buffer objectAtIndex:indexPath.section] ];
        AuthListViewCell *cell = (AuthListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
            UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
            
            cell = (AuthListViewCell *)uc.view;
            [cell setContent:dic];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        return cell;

    }
	NSString *CellIdentifier = @"ChannelManagerListViewCell";
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[buffer objectAtIndex:indexPath.section] ];
	ChannelManagerListViewCell *cell = (ChannelManagerListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];

		cell = (ChannelManagerListViewCell *)uc.view;
		[cell setContent:dic];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type) {
        return 152;
    }
	return 110;
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
	if (0 == section)
		return 58;
	return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (0 == section) {
		return  self.head_view;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([buffer count] == 0) {
		return;
	}
	[self.view hideToastActivity];
	
    if (1 == type) {
        AuthDetailViewController *ctrl = [[AuthDetailViewController alloc] initWithNibName:@"AuthDetailViewController" bundle:nil];
        ctrl.authId = [[buffer objectAtIndex:indexPath.section] objectForKey:@"authId"];
		ctrl.chuckStatus = [[buffer objectAtIndex:indexPath.section]objectForKey:@"auditState"];
        [self.navigationController pushViewController:ctrl animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        return;
    }
    
	ChannelManagerDetailViewController *ctrl = [[ChannelManagerDetailViewController alloc] initWithNibName:@"ChannelManagerDetailViewController" bundle:nil];
	ctrl.dataDic = [buffer objectAtIndex:indexPath.section];
	[self.navigationController pushViewController:ctrl animated:YES];
	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	}

}
#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
	[btn1 setTitle:@"未审核" forState:UIControlStateNormal];
	[btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn1 addTarget:self action:@selector(btn_order_select_click:) forControlEvents:UIControlEventTouchUpInside];
	btn1.frame = CGRectMake(0.0f, 0.0f, 160.0f, 44.0f);
	btn1.tag = 1;
	[im addSubview:btn1];

	btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn2 setTitle:@"已审核" forState:UIControlStateNormal];
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
		auditState = @"N";
	}
	else if ([sender tag] == 2){
		is_confirmed = YES;
		self.im_point.frame = CGRectMake(190.0f, 7.0f, 30.0f, 30.0f);
		auditState = @"Y";
	}
	[buffer removeAllObjects];
	[self loadData];
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


#pragma mark - loadData

- (void) loadData
{
	
	
	if ([buffer count] == 0)
		[self.view makeToastActivity];
	RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,type?AUTH_LIST_URL: CHANNEL_APPLY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:@"1" forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
	[req setParam:auditState forKey:@"auditState"];
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
	NSLog(@"%@=========",json);
	NSLog(@"%@======",[[json objectForKey:@"data"] objectForKey:@"msg"]);

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
	
	NSDictionary *dataDic;
	if (type == 0)
	{
	
	dataDic = [[json objectForKey:@"data"] objectForKey:@"data"];
	
	}else if (type == 1)
	{
		dataDic = [json objectForKey:@"data"];

	};
	
	NSArray *arr = [dataDic objectForKey:@"auditedArray"];
	if ([arr count] == 0) {
        arr = [dataDic objectForKey:@"record"];
    }
	if ([arr count] == 0) {
		[buffer removeAllObjects];
		[self.tableView reloadData];
		return;
	}
	[buffer removeAllObjects];
	[buffer addObjectsFromArray:arr];
	pageCount = [[dataDic objectForKey:@"pageCount"]integerValue];
	pageIndex = [[dataDic objectForKey:@"pageIndex"] integerValue]+1;
	[self.tableView reloadData];
}

- (void) fetchOld
{
	RRToken *token = [RRToken getInstance];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,type?AUTH_LIST_URL: CHANNEL_APPLY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
	[req setParam:auditState forKey:@"auditState"];
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

	NSDictionary *data = [[json objectForKey:@"data"] objectForKey:@"data"];
	NSArray *arr = [data objectForKey:@"auditedArray"];
    if ([arr count] == 0) {
        arr = [data objectForKey:@"record"];
    }
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
    type = index;
    [buffer removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    NSString *name = nil;
    if (0 == index) {
        name = @"渠道管理";
    }
    else if (1 == index){
        name = @"实名认证";
    }
    return name;
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

@end
