//
//  MemberUsrListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "FKRSearchBarTableViewController.h"

#import "MemberSearchDelegate.h"

@class MemberUsrListViewController;

@protocol MemberUsrListViewControllerDelegate <NSObject>

- (void)memberUsrListViewController:(MemberUsrListViewController*)ctrl didSelected:(NSDictionary *)person;

@end
@interface MemberUsrListViewController : FKRSearchBarTableViewController<UISearchDisplayDelegate>
{
    id<MemberUsrListViewControllerDelegate>delegate;
    NSMutableArray *buffer;
    NSMutableArray *bufferTmp;
    
    NSString *keyword;
    MemberSearchDelegate *delegate_srh;
    UISearchDisplayController *ctrl_srh;



}

@property(nonatomic,retain)id<MemberUsrListViewControllerDelegate>delegate;

@end
