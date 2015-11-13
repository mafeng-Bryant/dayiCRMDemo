//
//  MsgListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SINavigationMenuView.h"
#import "FPPopoverController.h"
#import "StoreListViewController.h"

@class searchDelegate;

@interface MsgListViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,FPPopoverControllerDelegate,StoreListViewControllerDelegate>
{
    BOOL is_show;
    searchDelegate		*delegate_srh;
    NSMutableArray *buffer;
    NSMutableArray *storeList;
    NSMutableArray *storeNameArray;

	UISearchDisplayController *ctrl_srh;
    NSUInteger  pageIndex;
    NSUInteger pageCount;
    NSTimer *timer;
    SINavigationMenuView *menu;
    FPPopoverController *popover;
    StoreListViewController *controller;
    EGORefreshTableHeaderView	*refreshHeaderView_bottom;
    EGORefreshTableHeaderView	*refreshHeaderView;

}

- (void)showDetailWithId:(NSString *)usrId name:(NSString *)_name;

- (void)loadData;

@end
