//
//  MsgListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MsgListViewController.h"
#import "searchDelegate.h"
#import "MsgListCell.h"
#import "FLViewController.h"
#import "CompileMemberMsgViewController.h"
#import "CSAddressBook.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWHomeCache.h"
#import "SIMenuButton.h"
#import "SIMenuConfiguration.h"
#import "StoreListViewController.h"
#import "GroupListViewController.h"
#import "ActivityListViewController.h"
#import "GroupDetailViewController.h"
#import "EditActivityViewController.h"
#import "DropDownListView.h"
#import "KxMenu.h"
@interface MsgListViewController ()<DropDownChooseDataSource,DropDownChooseDelegate>

@property(nonatomic,strong)IBOutlet UIView *list_view;
@property(nonatomic,strong)IBOutlet UISearchBar *search_bar;

@property (nonatomic, strong) SIMenuButton *menuButton;

//新加的
@property (nonatomic ,strong) DropDownListView *dropDownView;


//存储菜单单项的数组
@property (nonatomic,strong) NSMutableArray *kxMenuItemArray;

@end

@implementation MsgListViewController
{
	UIView *backView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_msg_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_msg_unselected"]];
		
		
		buffer = [NSMutableArray array];
		storeList = [NSMutableArray array];
		storeNameArray = [NSMutableArray array];
		
		pageIndex = 1;
		
		NSArray *a = [RWHomeCache readFromFile:@"storeList"];
		if ([a count])
		{
			[storeList addObjectsFromArray:a];
			[self setTitleView];
		}
		
		NSArray *arr = [RWHomeCache readFromFile:@"talkList"];
		if ([arr count])
		{
			[buffer addObjectsFromArray:arr];
			[self.tableView reloadData];
		}
		
		if (_kxMenuItemArray == nil)
		{
			_kxMenuItemArray = [[NSMutableArray alloc] init];
		}


    }
    return self;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self loadStoreList];
    [self  setTitleView];
    [self initSearchDisplayController];
	
	
	
	
    //bottom refresh header
	CGRect bottom_rect = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor whiteColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
	[self.tableView addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;
    
    CGRect top_rect = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height);
	refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:top_rect];
	refreshHeaderView.backgroundColor = [UIColor whiteColor];
	[self.tableView addSubview:refreshHeaderView];

	
    [self loadData];
    [self loadStoreList];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reLogin" object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadStoreList) name:@"reLogin" object:nil];
    //[[UIApplication sharedApplication] enabledRemoteNotificationTypes] // 判断消息推送是否打开
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:15
                                             target:self
                                           selector:@selector(loadData) userInfo:nil
                                            repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissListView];
	is_show = NO;
	//隐藏显示的view
	//[_dropDownView hideExtendedChooseView];
	[self onHideMenu];
	
	self.menuButton.isActive = NO;
    [timer invalidate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (animated) {
        [self.tableView flashScrollIndicators];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([buffer count]) {
        return [buffer count];
    }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSString *CellIdentifier = @"MsgListCell";
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    
    MsgListCell *cell = (MsgListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (MsgListCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    [self showDetailWithId:[dic objectForKey:@"userId"] name:[dic objectForKey:@"name"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 == [buffer count] &&
        tableView.contentSize.height > tableView.bounds.size.height && pageCount > pageIndex-1)
    {
        CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
        refreshHeaderView_bottom.frame = bottom_rect;
        refreshHeaderView_bottom.hidden = NO;
    }
}

- (void)showDetailWithId:(NSString *)usrId name:(NSString *)_name;
{
    FLViewController *ctrl = [[FLViewController alloc] initWithNibName:@"FLViewController" bundle:nil];
    ctrl.title = _name;
    ctrl.userId = usrId;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.search_bar.frame animated:animated];
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
    
    self.search_bar.placeholder = @"搜索";
    self.search_bar.delegate = self;
    
    [self.search_bar sizeToFit];
    
    self.tableView.tableHeaderView = self.search_bar;
	
	 [self setUpDropDownList];
    [self loadTitleView];
}

- (void)loadTitleView
{
    RRToken *token = [RRToken getInstance];
    NSString *storeName = [token getProperty:@"storeName"];
	NSLog(@"storeName === %@",storeName);
	
    if (self.menuButton) {
        [self.menuButton removeFromSuperview];
        self.menuButton = nil;
    }
    self.menuButton = [[SIMenuButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.menuButton.backgroundColor = [UIColor clearColor];
    self.menuButton.title.text = storeName;
    if ([storeList count]) {
        self.menuButton.isMore = YES;
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.titleView = self.menuButton;
    

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
	
	if (self.menuButton.isActive)
	{
		[self onHideMenu];
		self.menuButton.isActive = NO;
		
	}
	
    if (is_show) {
        [self dismissListView];
    }
    else{
		
		{
        self.list_view.alpha = 0.0f;
        self.list_view.frame = CGRectMake(180, 64, 134, 193);
        [self.tableView.window addSubview:self.list_view];
        [self showListView];
		}
    }
    
}

- (IBAction)btn_add_click:(id)sender
{
    [self dismissListView];
    if (1 == [sender tag]) {
        CompileMemberMsgViewController *ctrl = [[CompileMemberMsgViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (2 == [sender tag]){
        [[CSAddressBook shared] showPickerWithController:self andObject:self];
    }
//    else if (3 == [sender tag]){
//        GroupListViewController *ctrl = [[GroupListViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        ctrl.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
//    else if (4 == [sender tag]){
//        ActivityListViewController *ctrl = [[ActivityListViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        ctrl.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
    
    else if (3 == [sender tag]){
        GroupDetailViewController *ctrl = [[GroupDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (4 == [sender tag]){
        EditActivityViewController  *ctrl = [[EditActivityViewController alloc] initWithNibName:@"EditActivityViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
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

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData];

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
//第一个界面走这个方法
- (void)csAddressBook:(CSAddressBook *)addressBook selectedDoneWithRecipients:(NSDictionary *)recipients;
{
    NSString *tel = [recipients objectForKey:@"tel"];
    NSArray *arr = [tel componentsSeparatedByString:@"-"];
    if ([arr count]) {
        tel = [arr componentsJoinedByString:@""];
    }
    
    if (![self isValidateMobile:tel]) {
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
    
	//login fail
	if (![[[json objectForKey:@"data"] objectForKey:@"operationState"] isEqualToString:@"success"])
	{
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		NSLog(@"operationState ===== %@",[[json objectForKey:@"data"] objectForKey:@"operationState"]);

		return;
	}
    
    [SVProgressHUD dismissWithSuccess:@"添加成功!" afterDelay:1.5f];
}


- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    if (is_show) {
        [self dismissListView];
    }
	
	if (self.menuButton.isActive)
	{
		[self onHideMenu];
		self.menuButton.isActive = NO;
	}

	if (!scrollView.isDragging)
	{
		return;
	}
    if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshNormal];
	}
	else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshPulling];
	}
	

	if (refreshHeaderView_bottom.state == EGOOPullRefreshPulling &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 65.0f
         && pageCount > pageIndex-1)
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
    if (scrollView.contentOffset.y < - 65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self loadData];
	}

	if (scrollView.contentSize.height > scrollView.bounds.size.height &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f
         && pageCount > pageIndex-1)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [self fetchOld];
	}
}

- (void) updateTableView
{
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	self.tableView.contentInset = UIEdgeInsetsZero;
	[UIView commitAnimations];
	self.tableView.scrollEnabled = YES;
	[self.tableView reloadData];
}

- (void) updateTableViewBefore
{
	[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	refreshHeaderView_bottom.hidden = YES;
	
	self.tableView.contentInset = UIEdgeInsetsZero;
	[self.tableView reloadData];
}


#pragma mark -
- (void)loadData
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, TALK_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:@"1" forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
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
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        if([buffer count] == 0)
            [SVProgressHUD dismissWithError:@"获取数据失败!"];
        [self updateTableView];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        if([buffer count] == 0)
            [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        [buffer removeAllObjects];
        [self updateTableView];
        return;
    }
    
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    [RWHomeCache writeToFile:buffer withName:@"talkList"];
    pageCount = [[data objectForKey:@"pageCount"]integerValue];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
    [self updateTableView];
}

- (void) fetchOld
{
	
	RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, TALK_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
	[req setParam:@"50" forKey:@"pageSize"];
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
        [self updateTableViewBefore];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [self updateTableViewBefore];
        return;
    }
    
    [buffer addObjectsFromArray:arr];
    pageCount = [[data objectForKey:@"pageCount"]integerValue];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue]+1;
    [self updateTableViewBefore];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"登录失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)didSelectedStoreName:(NSString *)name
{
	
	
	
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storeDidChange" object:self];
    [self.view makeToastActivity];
    [self loadTitleView];
    [self onHideMenu];
    [buffer removeAllObjects];
    [self loadData];
}

- (void)onHandleMenuTap:(id)sender
{
	
	NSLog(@"aaaaaaaaaaaaaaaaaaa");
	
	if (is_show)
	{
		[self dismissListView];
		self.menuButton.isActive = YES;
	
	}
	
	
    if (self.menuButton.isActive) {
		
        [self onShowMenu];
		
    } else {
		
        [self onHideMenu];
    }
}

- (void)onShowMenu
{
    [self rotateArrow:M_PI];
//    if (controller) {
//        controller = nil;
//    }
//    controller = [[StoreListViewController alloc] initWithStyle:UITableViewStylePlain];
//	controller.buffer = storeList;
//    controller.delegate = self;
//    if (popover) {
//        popover = nil;
//    }
//    popover = [[FPPopoverController alloc] initWithViewController:controller];
//    popover.delegate = self;
//    popover.tint = FPPopoverBlackTint;
//    popover.arrowDirection = FPPopoverArrowDirectionAny;
//    [popover presentPopoverFromView:self.menuButton];
	[_kxMenuItemArray removeAllObjects];
	KxMenuItem *first = [KxMenuItem menuItem:@"商店列表" image:nil target:nil action:nil tag:0];
	[_kxMenuItemArray addObject:first];
	first.foreColor = dayiColor;
	first.alignment = NSTextAlignmentCenter;
	for (NSInteger index = 0; index < storeList.count; index ++) {
		
		NSDictionary *storeDict = storeList[index];
		NSString *name = storeDict[@"storeName"];
		
		KxMenuItem *item = [KxMenuItem menuItem:name image:nil target:self action:@selector(kxMenuPopClick:) tag:index+1];
		
		[_kxMenuItemArray addObject:item];
		
		
	}
	
	//[KxMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.menuButton.frame.origin.x, self.menuButton.frame.origin.y-44, self.menuButton.frame.size.width, self.menuButton.frame.size.height) menuItems:_kxMenuItemArray];
	backView.hidden = NO;
	
	
[KxMenu showMenuInView:self.view fromRect:CGRectMake(self.menuButton.frame.origin.x, self.menuButton.frame.origin.y-40, self.menuButton.frame.size.width, self.menuButton.frame.size.height) menuItems:_kxMenuItemArray];
	
}


#pragma mark---kxMenuPopClick
- (void) kxMenuPopClick: (KxMenuItem *)sender
{
	
	NSLog(@"storeName= %@",storeList[sender.tag-1][@"storeName"]);

	

	RRToken *token = [RRToken getInstance];
	[token setProperty:[[storeList objectAtIndex:sender.tag-1]objectForKey:@"storeName"] forKey:@"storeName"];
	[token setProperty:[[storeList objectAtIndex:sender.tag-1] objectForKey:@"storeId"] forKey:@"storeId"];
	[token saveToFile];
	[[NSNotificationCenter defaultCenter]postNotificationName:@"storeDidChang" object:self];
	[self.view makeToastActivity];
	
	
	[self.tableView reloadData];
	
	[self loadTitleView];
	
	[self onHideMenu];
	
	//[buffer removeAllObjects];
	
	[self loadData];
	[self.tableView reloadData];
	[UIView animateWithDuration:0.2 animations:^{
		[self rotateArrow:0];
		
	} completion:^(BOOL finished) {
		
		[KxMenu dismissMenu];
		
	}];

}

- (void)onHideMenu
{
    [self rotateArrow:0];

    [popover dismissPopoverAnimated:YES];
	[popover removeObservers];
    controller = nil;
    popover = nil;
	[KxMenu dismissMenu];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}


- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController;
{
    [self rotateArrow:0];
    self.menuButton.isActive = NO;
}

- (void)loadStoreList
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_STORELIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadedStoreList:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoadedStoreList: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];

	NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"storeList"];
    if ([arr count] == 0) {
        NSLog(@"%@",[data objectForKey:@"msg"]);
        return;
    }
    
    [storeList removeAllObjects];
    [storeList addObjectsFromArray:arr];
    [RWHomeCache writeToFile:storeList withName:@"storeList"];
    [self loadTitleView];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


- (void)dealloc
{
	popover = nil;
	self.menuButton = nil;
	popover.delegate = nil;

}

- (void)setUpDropDownList
{
	if (self.dropDownView)
		self.dropDownView = nil;
	
	self.dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(20,5,140, 40) dataSource:self delegate:self];
	self.dropDownView.mSuperView = self.view;
	RRToken *token = [RRToken getInstance];
	NSString *storeName = [token getProperty:@"storeName"];

	[self.dropDownView setTitle:storeName inSection:0];
	self.dropDownView.backgroundColor = dayiColor;
	self.navigationItem.titleView = self.dropDownView;
	[self loadData];
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
//	//type = index;
//	[buffer removeAllObjects];
//	[self.tableView reloadData];
//	[self loadData];
//	if (index == 0)
//	{
//		return;
//	}else{
	
	
	RRToken *token = [RRToken getInstance];
	[token setProperty:[[storeList objectAtIndex:index] objectForKey:@"storeName"] forKey:@"storeName"];
	[token setProperty:[[storeList objectAtIndex:index] objectForKey:@"storeId"] forKey:@"storeId"];
	[token saveToFile];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"storeDidChange" object:self];
    [self.view makeToastActivity];
	
	[self loadData];
	//[storeList removeAllObjects];
	[self.tableView reloadData];
	//}
	
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
	return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
	return storeList.count ;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
	NSString *name = nil;
//	if (0 == index) {
//		name = @"渠道管理";
//	}
//	else if (1 == index){
//		name = @"实名认证";
//	}
	
//	if (0 == index) {
//				name = @"门店列表";
//	}
   if (storeList.count > 0)
	{
		NSDictionary *dic = storeList[index];
		name = [dic objectForKey:@"storeName"];
	}
	return name;
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
	return 0;
}



@end
