//
//  HistoryListViewController.m
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "HistoryListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface HistoryListViewController ()

@end

@implementation HistoryListViewController
@synthesize applyUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"历史申请记录";
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
	[self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (0 == [buffer count]) {
		return 1;
	}
    return [buffer count];
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

	NSString *cell_id = @"cell";

	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
	}

	NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
	UIFont *font = [UIFont systemFontOfSize:15.0f];
	cell.textLabel.text = [dic objectForKey:@"createTime"];
	cell.textLabel.font = font;

	cell.detailTextLabel.text = [dic objectForKey:@"number"];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
	cell.detailTextLabel.textColor = [UIColor lightGrayColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)loadData
{
	if ([buffer count] == 0)
		[self.view makeToastActivity];
	RRToken *token = [RRToken getInstance];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,HISTORY_RECORD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:applyUser forKey:@"applyUser"];
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
	NSArray *arr = [data objectForKey:@"applyHistoryRecord"];
	if ([arr count] == 0) {
		[buffer removeAllObjects];
		[self.tableView reloadData];
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
