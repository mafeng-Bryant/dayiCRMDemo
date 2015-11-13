//
//  MemberUsrListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MemberUsrListViewController.h"
#import "pinyin.h"
#import "MemberListCell.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface MemberUsrListViewController ()

@end

@implementation MemberUsrListViewController
@synthesize delegate;

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes
{
    if ((self = [super initWithSectionIndexes:showSectionIndexes])) {
        self.title = @"选择下单人";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    // The search bar is hidden when the view becomes visible the first time
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));

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
        
    }
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchBar.placeholder = @"搜索";

    buffer = [NSMutableArray array];
    bufferTmp = [NSMutableArray array];
    
    ctrl_srh = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	ctrl_srh.delegate = self;
	ctrl_srh.searchResultsDataSource = nil;
	ctrl_srh.searchResultsDelegate = nil;

    [self loadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchBar.frame animated:animated];
}

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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
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
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    if (delegate && [delegate respondsToSelector:@selector(memberUsrListViewController:didSelected:)]) {
        [delegate memberUsrListViewController:self didSelected:dic];
    }
}
#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MEMBERUSER_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if ([keyword length]) {
        [req setParam:keyword forKey:@"keyword"];
    }
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
    
    NSDictionary *data = [[json objectForKey:@"data"] objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"customers"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [bufferTmp removeAllObjects];
    [bufferTmp addObjectsFromArray:arr];
    [buffer removeAllObjects];
    [self filtBuffer];
    [self.tableView reloadData];
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
    
    for (NSDictionary *dic in bufferTmp) {
        NSString *nickname = [dic objectForKey:@"customerName"];
        if ([nickname length] == 0) {
            continue;
        }
        
        NSRange range = NSMakeRange(0, 1);
        NSString *subString = [nickname substringWithRange:range];
        
        NSString *firstLetter ;
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

- (BOOL) isHanZi:(NSString *)str
{
//    const char *cString = [str UTF8String];
//    if (strlen(cString) == 3)
//    {
//        return YES;
//    }
//    return NO;
	return YES;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
	delegate_srh = [[MemberSearchDelegate alloc] initWithTableView:tableView];
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

@end
