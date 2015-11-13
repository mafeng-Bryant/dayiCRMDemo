//
//  MemberListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class searchDelegate;

@interface MemberListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    BOOL is_show;
    searchDelegate		*delegate_srh;
    NSMutableArray *buffer;
    NSMutableArray *bufferTmp;

	UISearchDisplayController *ctrl_srh;
    NSUInteger  pageIndex;
    NSUInteger  pageCount;

    EGORefreshTableHeaderView	*refreshHeaderView_bottom;

}

@end
