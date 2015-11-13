//
//  ExecutorListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ExecutorListViewController.h"
#import "pinyin.h"
#import "ExecutorListCell.h"
#import "CompileMemberMsgViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface ExecutorListViewController ()

@end

@implementation ExecutorListViewController
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
    self.title = @"选择执行人";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_add;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_add = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_member"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_add_click:)];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
        self.tableView.sectionIndexColor = [UIColor darkGrayColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setImage:[UIImage imageNamed:@"add_member"] forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_add = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    //self.navigationItem.rightBarButtonItem = btn_add;
    //bottom refresh header
	CGRect bottom_rect = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor whiteColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
	[self.tableView addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;
    
    buffer = [NSMutableArray array];
    pageIndex = 1;
    [self loadData];
}

- (void)dealloc
{
    self.view=nil;
    buffer=nil;
    refreshHeaderView_bottom=nil;
    delegate=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([buffer count] == 0) {
        return 1;
    }
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([buffer count] == 0) {
        return 1;
    }
    return [[[buffer objectAtIndex:section] objectForKey:@"data"] count];
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
        cell.textLabel.text = is_loading?@"加载中":@"无数据";
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    NSString *CellIdentifier = @"ExecutorListCell";
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    
     ExecutorListCell*cell = (ExecutorListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (ExecutorListCell *)uc.view;
		[cell setContent:dic];
      }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *key = [NSMutableArray array];
    for (NSDictionary *dic in buffer) {
        [key addObject:[dic objectForKey:@"letter"]];
    }
    return key;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([buffer count] == 0) {
        return nil;
    }
    return [[buffer objectAtIndex:section] objectForKey:@"letter"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        return;
    }
    if (delegate ) {
        [delegate executorListViewDidSelected:[[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (1 == indexPath.section)
	{
		if (indexPath.row + 1 == [buffer count] &&
			tableView.contentSize.height > tableView.bounds.size.height)
		{
			CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
			refreshHeaderView_bottom.frame = bottom_rect;
			refreshHeaderView_bottom.hidden = NO;
		}
	}
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	if (!scrollView.isDragging)
	{
		return;
	}
    
	if (refreshHeaderView_bottom.state == EGOOPullRefreshPulling &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 65.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	}
	else if (refreshHeaderView_bottom.state == EGOOPullRefreshNormalUP &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshPulling];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentSize.height > scrollView.bounds.size.height &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
       // [self fetchOld];
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
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn_add_click:(id)sender
{
    CompileMemberMsgViewController *ctrl = [[CompileMemberMsgViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark -
#pragma mark loadData

- (void)loadData
{
    is_loading = YES;
    [self.tableView reloadData];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, EXECUTOR_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"10" forKey:@"pageSize"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    is_loading = NO;

	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        [self.tableView reloadData];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        [self.tableView reloadData];
        return;
    }
    
    [buffer addObjectsFromArray:arr];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
	//把buffer里面的数据进行按字母排序
    [self filtBuffer];
    [self.tableView reloadData];
}

- (void) fetchOld
{
	
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, EXECUTOR_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"10" forKey:@"pageSize"];
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
	
    NSLog(@"%@",json);
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"获取失败!" afterDelay:1.5f];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [SVProgressHUD dismissWithError:@"暂无更多数据!" afterDelay:1.5f];
        return;
    }
    
    [SVProgressHUD dismissWithSuccess:@"" afterDelay:1.0f];
    
    [buffer addObjectsFromArray:arr];
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


- (void)filtBuffer
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in buffer) {
        NSString *nickname = [dic objectForKey:@"name"];
		//得到首字母
        NSString *firstLetter = [NSString stringWithFormat:@"%c", pinyinFirstLetter([nickname characterAtIndex:0])];
		NSLog(@"firstLetter ==== %@",firstLetter);
		
        BOOL is_contain = NO;
        //问题
		NSLog(@"firstLetter ========== %@",[firstLetter capitalizedString]);
        for (NSDictionary *dict in array) {
            if ([[dict objectForKey:@"letter"] isEqualToString:[firstLetter capitalizedString]]) {
                is_contain = YES;
                NSMutableArray *a = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
                [a addObject:dic];
                NSDictionary *d = @{@"letter": [firstLetter capitalizedString],@"data":a};
                [array replaceObjectAtIndex:[array indexOfObject:dict] withObject:d];
                break;
            }
        }
        
        if (!is_contain) {
            NSArray *a = @[dic];
            NSDictionary *d = @{@"letter": [firstLetter capitalizedString],@"data":a};
            [array addObject:d];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"letter" ascending:YES];
    NSArray *tempArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:tempArray];
}

- (void)compileMemberMsgViewDidAdd:(NSDictionary *)dic
{
    if (delegate ) {
        [delegate executorListViewDidSelected:dic];
    }
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
