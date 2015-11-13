//
//  MemberListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MemberListViewController.h"
#import "searchDelegate.h"
#import "pinyin.h"
#import "MemberListCell.h"
#import "MemberDetailViewController.h"
#import "CompileMemberMsgViewController.h"
#import "CSAddressBook.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWHomeCache.h"
#import "BATableView.h"

@interface MemberListViewController ()<BATableViewDelegate>
@property(nonatomic,strong)IBOutlet UIView *list_view;
@property(nonatomic,strong)IBOutlet UISearchBar *search_bar;
@property(nonatomic,strong)IBOutlet BATableView *table_view;

@end

@implementation MemberListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"联系人";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_profile_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_profile_unselected"]];
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleView];
    
    [self createTableView];
    
    //bottom refresh header
	CGRect bottom_rect = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor clearColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
	[self.table_view addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;
    
    buffer = [NSMutableArray array];
    bufferTmp = [NSMutableArray array];
    pageIndex = 1;
    
 	NSArray *arr = [RWHomeCache readFromFile:@"memberList"];
	if ([arr count])
	{
        [buffer addObjectsFromArray:arr];
		[self.table_view reloadData];
	}
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"storeDidChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"reLogin" object:nil];

    [self loadData];

}

- (void) createTableView {
    if (iPhone5){
        self.table_view = [[BATableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 110)];
    }
    else{
        self.table_view = [[BATableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 200)];
    }
    self.table_view.delegate = self;
    [self.view addSubview:self.table_view];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.textLabel.text = @"无数据";
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    NSString *CellIdentifier = @"MemberListCell";
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    MemberListCell *cell = (MemberListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (MemberListCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissListView];
    if ([buffer count] == 0) {
        return;
    }
    NSString *uid = [[[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"id"];
    MemberDetailViewController *ctrl = [[MemberDetailViewController alloc] initWithNibName:@"MemberDetailViewController" bundle:nil];
    ctrl.uid = uid;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([buffer count] == indexPath.section+1)
	{
		if (tableView.contentSize.height > tableView.bounds.size.height&& pageCount > pageIndex-1)
		{
			CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
			refreshHeaderView_bottom.frame = bottom_rect;
			refreshHeaderView_bottom.hidden = NO;
		}
	}
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
        return NO;
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self updateItemAtIndexPath:indexPath withString:nil];
    }
}


- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    if (is_show) {
        [self dismissListView];
    }

	if (!scrollView.isDragging)
	{
		return;
	}
    
	if (refreshHeaderView_bottom.state == EGOOPullRefreshPulling &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 65.0f
        && pageCount > pageIndex-1)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	}
	else if (refreshHeaderView_bottom.state == EGOOPullRefreshNormalUP &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f&& pageCount > pageIndex-1)
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
		self.table_view.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [self fetchOld];
	}
}

- (void) updateTableViewBefore
{
	[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	refreshHeaderView_bottom.hidden = YES;
	self.table_view.tableView.contentInset = UIEdgeInsetsZero;
	[self.table_view reloadData];
}


#pragma mark -

- (void)setTitleView
{
    UIBarButtonItem *backBtn;
    UIBarButtonItem *btn_list;
    
    CGRect rect ;
    if (IOS7)
    {
        backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        btn_list = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_member"] style:UIBarButtonItemStylePlain target:self action:@selector(btn_list_click:)];
        rect = CGRectMake(60, 20, 200, 44);
        self.navigationItem.backBarButtonItem = backBtn;
    }
    
    else
    {
        self.navigationItem.hidesBackButton = YES;
        rect = CGRectMake(60, 0, 200, 44);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"add_member"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_list_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_list = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    self.navigationItem.rightBarButtonItem = btn_list;
    self.search_bar.frame = CGRectMake(0,0, 320, 44);
    //self.table_view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //[self.view addSubview:self.search_bar];
}

- (void)initSearchDisplayController
{
    if (!IOS7) {
        [self resetSearchBar:self.search_bar];
        [self.search_bar setBackgroundColor:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    }
    ctrl_srh = [[UISearchDisplayController alloc] initWithSearchBar:self.search_bar contentsController:self];
	ctrl_srh.delegate = self;
	ctrl_srh.searchResultsDataSource = nil;
	ctrl_srh.searchResultsDelegate = nil;
    
}
- (void)showListView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.list_view.alpha = 1.0f;
    [UIView commitAnimations];
    is_show = !is_show;
}

- (void)dismissListView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.list_view.alpha = 0.0f;
    [UIView commitAnimations];
    is_show = !is_show;
}

- (void)btn_list_click:(id)sender
{
	
    if (is_show) {
        [self dismissListView];
    }
    else{
        self.list_view.alpha = 0.0f;
        self.list_view.frame = CGRectMake(180, 64, 134, 102);
        [self.view.window addSubview:self.list_view];
        [self showListView];
    }
    
}

- (IBAction)btn_add_click:(id)sender
{
    [self dismissListView];
    if (1 == [sender tag]) {
        CompileMemberMsgViewController *ctrl = [[CompileMemberMsgViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (2 == [sender tag]){
        [[CSAddressBook shared] showPickerWithController:self andObject:self];
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
	delegate_srh = [[searchDelegate alloc] initWithTableView:tableView];
	delegate_srh.view_controller = self;
	ctrl_srh.searchResultsDataSource = delegate_srh;
	ctrl_srh.searchResultsDelegate = delegate_srh;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if (IOS7) {
        self.search_bar.frame = CGRectMake(0,20, 320, 44);
    }
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.table_view reloadData];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    if (IOS7) {
        self.search_bar.frame = CGRectMake(0,0, 320, 44);
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
	delegate_srh.keyword = searchText;
	[delegate_srh search];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	delegate_srh.keyword = searchBar.text;
	[delegate_srh search];
}

- (void)resetSearchBar:(UISearchBar *)search
{
    [[search.subviews objectAtIndex:0] setHidden:YES];
    [[search.subviews objectAtIndex:0] removeFromSuperview];
    
    for (UIView *subview in search.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)filtBuffer
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in bufferTmp) {
        NSString *nickname = [dic objectForKey:@"name"];
        if ([nickname length] == 0) {
            continue;
        }
        
        NSRange range = NSMakeRange(0, 1);
        NSLog(@"%@",nickname);
        NSString *subString = [nickname substringWithRange:range];
        
        NSString *firstLetter ;
		
		//廖斌改
		
        if (![self isHanZi:subString] && ![self isPureInt:subString])
		//if (![self isPureInt:subString])
        {
            firstLetter = [subString lowercaseString];
        }
        else
        {
            firstLetter = [NSString stringWithFormat:@"%c", pinyinFirstLetter([nickname characterAtIndex:0])];
        }
        
        BOOL is_contain = NO;
        
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
    
    NSDictionary *dic = [buffer objectAtIndex:0];
    if ([[dic objectForKey:@"letter"] isEqualToString:@"#"]) {
        [buffer insertObject:dic atIndex:[buffer count]];
        [buffer removeObjectAtIndex:0];
    }
}
//选中通讯录某个人以后执行这个方法 7
- (void)csAddressBook:(CSAddressBook *)addressBook selectedDoneWithRecipients:(NSDictionary *)recipients;
{
	
	NSString *tel = [recipients objectForKey:@"tel"];
	NSArray *arr = [tel componentsSeparatedByString:@"-"];
	if ([arr count]) {
		tel = [arr componentsJoinedByString:@""];
	}

	if (![self isValidateMobile:tel]){//[recipients objectForKey:@"tel"]]) {
        [self.view.window makeToast:@"手机号码不符合规定!"];
        return;
    }
    [SVProgressHUD showWithStatus:@"数据上传中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, IMPORT_MEMBER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[recipients objectForKey:@"tel"] forKey:@"mobile"];
    [req setParam:[recipients objectForKey:@"name"] forKey:@"name"];
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onAddMember:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}

- (void) onAddMember: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
	//login fail
	if (![[[json objectForKey:@"data"] objectForKey:@"operationState"] isEqualToString:@"success"])
	{
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    [SVProgressHUD dismissWithSuccess:@"操作成功!" afterDelay:1.5f];
}

- (void) updateItemAtIndexPath:(NSIndexPath *)indexPath withString: (NSString *)string
{
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    [self delMemberWithId:[dic objectForKey:@"id"]];
}

#pragma mark -
- (void)reloadData
{
    [buffer removeAllObjects];
    [self.table_view reloadData];
    [self loadData];
}

- (void)loadData
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:@"1" forKey:@"pageIndex"];
    [req setParam:@"200" forKey:@"pageSize"];
    [req setHTTPMethod:@"POST"];
	
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [buffer removeAllObjects];
    [self.table_view reloadData];
    
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
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [bufferTmp removeAllObjects];
    [bufferTmp addObjectsFromArray:arr];

    [buffer removeAllObjects];
    [self filtBuffer];
    
    [RWHomeCache writeToFile:buffer withName:@"memberList"];
    pageCount = [[data objectForKey:@"pageCount"]integerValue];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
    [self.table_view reloadData];
}

- (void) fetchOld
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"200" forKey:@"pageSize"];
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
        [SVProgressHUD dismissWithSuccess:@"暂无更多数据!" afterDelay:1.5f];
        [self updateTableViewBefore];
        return;
    }
    
    
    [bufferTmp addObjectsFromArray:arr];
    [self filtBuffer];
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

- (void) delMemberWithId:(NSString *)uid
{
    [SVProgressHUD showWithStatus:@"删除会员中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_MEMBER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
    [req setParam:uid forKey:@"id"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onDelMember:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];

}

- (void) onDelMember: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"删除失败!" afterDelay:1.5f];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    if ([[data objectForKey:@"operationState"] isEqualToString:@"success"]) {
        [SVProgressHUD dismissWithSuccess:@"删除成功" afterDelay:1.0f];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[data objectForKey:@"msg"]];
    }
    
    [self loadData];
    [self.table_view.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL) isHanZi:(NSString *)str
{
//    const char *cString = [str UTF8String];
//    if (!cString) {
//        return NO;
//    }
//    if (strlen(cString) == 3)
//    {
//        return YES;
//    }
    return YES;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
@end
