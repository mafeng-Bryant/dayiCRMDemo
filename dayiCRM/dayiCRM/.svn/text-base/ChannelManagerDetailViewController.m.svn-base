//
//  ChannelManagerDetailViewController.m
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ChannelManagerDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "ChannelManagerDetaiViewCell.h"
#import "HistoryListViewController.h"

@interface ChannelManagerDetailViewController ()

@end

@implementation ChannelManagerDetailViewController
@synthesize dataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"渠道管理";
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
	[self setUpHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.section) {
		NSString *CellIdentifier = @"ChannelManagerDetaiViewCell";
		ChannelManagerDetaiViewCell *cell = (ChannelManagerDetaiViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (nil == cell)
		{
			UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];

			cell = (ChannelManagerDetaiViewCell *)uc.view;
			[cell setContent:dataDic];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
	}

	NSString *cell_id = @"empty_cell";

	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
	}

	UIFont *font = [UIFont systemFontOfSize:15.0f];
	cell.textLabel.text = @"历史记录";
	cell.textLabel.font = font;
	cell.textLabel.textAlignment = NSTextAlignmentLeft;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (0 == section) {
		return 80;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (1 == section) {
		return 127;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (0 == section) {
		return head_view;
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (1 == section && [[dataDic objectForKey:@"auditState"] integerValue] == 3) {
		return foot_view;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 == indexPath.section) {
		return 128;
	}
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.view hideToastActivity];
    if(0 == indexPath.row && 1 == indexPath.section){
        HistoryListViewController *ctrl = [[HistoryListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.applyUser = [dataDic objectForKey:@"applyUser"];
        [self.navigationController pushViewController:ctrl animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_pass_click:(id)sender
{
	applyStatus = [NSString stringWithFormat:@"%ld",(long)[sender tag] ];
	[self updata];
}

- (void)setUpHeadView
{
	lb_name.text = [NSString stringWithFormat:@"申请人:%@",[dataDic objectForKey:@"name"]];
	NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"createTime"] doubleValue]/1000]];
	lb_time.text = [@"申请时间:" stringByAppendingString:post_date];
	if([[dataDic objectForKey:@"auditState"] integerValue] == 1) {
		im_status.image = [UIImage imageNamed:@"img80.png"];
	}
	else if([[dataDic objectForKey:@"auditState"] integerValue] == 2) {
		im_status.image = [UIImage imageNamed:@"img81.png"];
	}
	else{
		im_status.alpha = 0.0f;
	}
	[im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDic objectForKey:@"avatarId"]]];
}

#pragma mark - loadData
- (void)updata
{
	[SVProgressHUD showWithStatus:@"上传数据中"];
	RRToken *token = [RRToken getInstance];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,AUDIT_RECORD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[dataDic objectForKey:@"applyId"] forKey:@"applyId"];
	[req setParam:applyStatus forKey:@"applyStatu"];
	[req setHTTPMethod:@"POST"];

	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];

	NSDictionary *json = [loader getJSONData];
	NSLog(@"%@",json);
	NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);

	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];

		//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
		[SVProgressHUD dismiss];
		[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
	if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
		[SVProgressHUD dismiss];
		[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}

	[[NSNotificationCenter defaultCenter]postNotificationName:@"ChannelManagerDidChange" object:nil];
	[SVProgressHUD dismissWithSuccess:@"操作成功!"];
	[self performSelector:@selector(popViewContgroller) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
	[SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)popViewContgroller
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
