//
//  searchDelegate.m
//  dayiCRM
//
//  Created by Fang on 14-4-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "searchDelegate.h"
#import "FLViewController.h"
#import "MemberDetailViewController.h"
#import "StockDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation searchDelegate
@synthesize view_controller;
@synthesize tableView;
@synthesize keyword;

- (id) initWithTableView:(UITableView *)tableview
{
	self = [super init];
	
	if (self)
	{
		tableView = tableview;
		buffer = [[NSMutableArray alloc] init];
        inventorybuffer = [[NSMutableArray alloc] init];
		talkbuffer = [[NSMutableArray alloc] init];
		memberbuffer = [[NSMutableArray alloc] init];

        pageIndex = 1;
	}
	
	return self;
}

- (void)dealloc
{
    view_controller = nil;
	tableView = nil;
	inventoryData = nil;
    talkData = nil;
    memberData = nil;
	buffer = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSArray *array = [NSArray array];

    switch (section) {
        case 0:
            dic = inventoryData;
            array = inventorybuffer;
            break;
        case 1:
            dic = talkData;
            array = talkbuffer;
            break;
        case 2:
            dic = memberData;
            array = memberbuffer;
            break;
   
        default:
            break;
    }
    
    if ([[dic objectForKey:@"pageIndex"] integerValue] ==
        [[dic objectForKey:@"pageCount"] integerValue]) {
        if ([array count] > 0) {
            return [array count];
        }
        else
        {
            return 0;
        }
    }
    else if ([[dic objectForKey:@"pageIndex"] integerValue] <
             [[dic objectForKey:@"pageCount"] integerValue])
    {
        return [array count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    if (0 == indexPath.section) {
        if ([inventorybuffer count] == 0) {
            static NSString *cell_id = @"empty_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
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
        else if (indexPath.row == [inventorybuffer count])
        {
            static NSString *cell_id = @"more_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = @"加载更多";
            cell.textLabel.font = font;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
        else
        {
            static NSString *cell_id = @"member_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            NSDictionary *dic = [inventorybuffer objectAtIndex:indexPath.row];
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"productName"],[dic objectForKey:@"pici"]];
            
            NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dic objectForKey:@"productAvatarId"]];
            UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
            if (avatar_im)
            {
                [cell.imageView setImage:avatar_im];
            }
            else
            {
                RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                     parentView:cell.imageView
                                                                       delegate:self
                                                               defaultImageName:@"default_pic_avatar"];
                
                [cell.imageView setImage:r_img];
            }

            cell.textLabel.font = font;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
    }
    if (1 == indexPath.section) {
        if ([talkbuffer count] == 0) {
            static NSString *cell_id = @"empty_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
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
        else if (indexPath.row == [talkbuffer count])
        {
            static NSString *cell_id = @"more_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = @"加载更多";
            cell.textLabel.font = font;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
        else
        {
            static NSString *cell_id = @"msg_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_id];
            }
            
            NSDictionary *dic = [talkbuffer objectAtIndex:indexPath.row];
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = [dic objectForKey:@"name"];
            NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dic objectForKey:@"avatarId"]];
            UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
            if (avatar_im)
            {
                [cell.imageView setImage:avatar_im];
            }
            else
            {
                RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                     parentView:cell.imageView
                                                                       delegate:self
                                                               defaultImageName:@"default_pic_avatar"];
                
                [cell.imageView setImage:r_img];
            }
            cell.detailTextLabel.text = [dic objectForKey:@"content"];
            cell.textLabel.font = font;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
    }
    
    if (2 == indexPath.section) {
        if ([memberbuffer count] == 0) {
            static NSString *cell_id = @"empty_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
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
        else if (indexPath.row == [memberbuffer count])
        {
            static NSString *cell_id = @"more_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = @"加载更多";
            cell.textLabel.font = font;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
        else
        {
            static NSString *cell_id = @"member_cell";
            UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:cell_id];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            NSDictionary *dic = [memberbuffer objectAtIndex:indexPath.row];
            UIFont *font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = [dic objectForKey:@"name"];
            NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dic objectForKey:@"pictureId"]];
            UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
            if (avatar_im)
            {
                [cell.imageView setImage:avatar_im];
            }
            else
            {
                RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                     parentView:cell.imageView
                                                                       delegate:self
                                                               defaultImageName:@"default_pic_avatar"];
                
                [cell.imageView setImage:r_img];
            }
            cell.textLabel.font = font;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![buffer count]) {
        return nil;
    }
    NSString *title;
    if (section == 1) {
        title = @"聊天记录";
    }
    else if (section == 2) {
        title = @"联系人";
    }
    else if (section == 0) {
        title = @"库存";
    }
    return title;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSArray *array = [NSArray array];
    
    switch (indexPath.section) {
        case 0:
            dic = inventoryData;
            array = inventorybuffer;
            break;
        case 1:
            dic = talkData;
            array = talkbuffer;
            break;
        case 2:
            dic = memberData;
            array = memberbuffer;
            break;
            
        default:
            break;
    }

    if (indexPath.row == [array count])
    {
        pageIndex = [[dic objectForKey:@"pageIndex"] integerValue] + 1;
        type = [dic objectForKey:@"type"];
        [self searchWithType];
        return;
    }
    
    if (indexPath.section == 1) {

        [self.view_controller.searchDisplayController.searchBar resignFirstResponder];
        FLViewController *ctrl = [[FLViewController alloc] initWithNibName:@"FLViewController" bundle:nil];
        ctrl.title = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
        ctrl.userId = [[array objectAtIndex:indexPath.row] objectForKey:@"toUserId"];
        ctrl.msgId = [[array objectAtIndex:indexPath.row] objectForKey:@"id"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.view_controller.navigationController pushViewController:ctrl animated:YES];
        if ([self.view_controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.view_controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (indexPath.section == 2) {
        NSDictionary *dic = [memberbuffer objectAtIndex:indexPath.row];
        MemberDetailViewController *ctrl = [[MemberDetailViewController alloc] initWithNibName:@"MemberDetailViewController" bundle:nil];
        ctrl.uid = [dic objectForKey:@"id"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.view_controller.navigationController pushViewController:ctrl animated:YES];
        if ([self.view_controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.view_controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }


    }
    else if (indexPath.section == 0) {
        NSDictionary *dic = [inventorybuffer objectAtIndex:indexPath.row];
        StockDetailViewController *ctrl = [[StockDetailViewController alloc] initWithNibName:@"StockDetailViewController" bundle:nil];
        ctrl.title_name = [dic objectForKey:@"productName"];
        ctrl.sid = [dic objectForKey:@"productId"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.view_controller.navigationController pushViewController:ctrl animated:YES];
        if ([self.view_controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.view_controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }


    }

}

- (void) search
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,GLOABL_SEARCH_URL];
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
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"搜索失败!" afterDelay:1.5f];
		return;
	}
    
    if ([buffer count]) {
        [buffer removeAllObjects];
        [inventorybuffer removeAllObjects];
        [talkbuffer removeAllObjects];
        [memberbuffer removeAllObjects];
    }
    [buffer addObject:[json objectForKey:@"data"]];
    
    NSDictionary *data = [json objectForKey:@"data"];
    inventoryData = [data objectForKey:@"inventoryData"];
    talkData = [data objectForKey:@"talkData"];
    memberData = [data objectForKey:@"memberData"];
    
    [inventorybuffer addObjectsFromArray:[inventoryData objectForKey:@"records"]];
    [talkbuffer addObjectsFromArray:[talkData objectForKey:@"records"]];
    [memberbuffer addObjectsFromArray:[memberData objectForKey:@"records"]];

    [self.tableView reloadData];

}

- (void) searchWithType
{
    [SVProgressHUD showWithStatus:@"搜索中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,GLOABL_SEARCH_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.keyword forKey:@"keyword"];
    [req setParam:type forKey:@"type"];
    [req setParam:[NSString stringWithFormat:@"%d",pageIndex ] forKey:@"pageIndex"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSearchWithType:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onSearchWithType: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"搜索失败!" afterDelay:1.5f];
		return;
	}
    
    [SVProgressHUD dismissWithSuccess:@"搜索完成" afterDelay:1.0f];
    [buffer addObject:[json objectForKey:@"data"]];
    NSDictionary *data = [json objectForKey:@"data"];
    if ([[data objectForKey:@"type"] integerValue] == 0) {
        talkData = [data objectForKey:@"talkData"];
        [talkbuffer addObjectsFromArray:[talkData objectForKey:@"records"]];
    }
    else if ([[data objectForKey:@"type"] integerValue] == 1) {
        memberData = [data objectForKey:@"memberData"];
        [memberbuffer addObjectsFromArray:[memberData objectForKey:@"records"]];

    }
    else if ([[data objectForKey:@"type"] integerValue] == 2) {
        inventoryData = [data objectForKey:@"inventoryData"];
        [inventorybuffer addObjectsFromArray:[inventoryData objectForKey:@"records"]];
    }

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
