//
//  MemberSearchDelegate.m
//  dayiCRM
//
//  Created by Fang on 14-9-12.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MemberSearchDelegate.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "MemberListCell.h"
#import "pinyin.h"
#import "MemberUsrListViewController.h"

@implementation MemberSearchDelegate
@synthesize view_controller;
@synthesize tableView;
@synthesize keyword;

- (id) initWithTableView:(UITableView *)tableview
{
	self = [super init];
	
	if (self)
	{
		tableView = tableview;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		buffer = [[NSMutableArray alloc] init];
        bufferTmp = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
    view_controller = nil;
	tableView = nil;
	buffer = nil;
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

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        static NSString *cell_id = @"empty_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[TableView dequeueReusableCellWithIdentifier:cell_id];
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
    
    MemberListCell *cell = (MemberListCell *)[TableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    MemberUsrListViewController *ctrl = (MemberUsrListViewController *)self.view_controller;
    if (ctrl.delegate && [ctrl.delegate respondsToSelector:@selector(memberUsrListViewController:didSelected:)]) {
        [ctrl.delegate memberUsrListViewController:ctrl didSelected:dic];
    }
}

- (void) search
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,MEMBERUSER_LIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.keyword forKey:@"keyword"];
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
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"搜索失败!" afterDelay:1.5f];
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
    const char *cString = [str UTF8String];
    if (strlen(cString) == 3)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
