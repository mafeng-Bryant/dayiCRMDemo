//
//  ExecutorListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompileMemberMsgViewController.h"
#import "EGORefreshTableHeaderView.h"

@protocol ExecutorListViewDelegate <NSObject>

@optional

- (void)executorListViewDidSelected:(NSDictionary *)dic;

@end

@interface ExecutorListViewController : UITableViewController<CompileMemberMsgDelegate>
{
    NSMutableArray *buffer;
    NSUInteger pageIndex;
    BOOL    is_loading;
    EGORefreshTableHeaderView	*refreshHeaderView_bottom;

    __weak id <ExecutorListViewDelegate> delegate;
}

@property(nonatomic,weak)id <ExecutorListViewDelegate>delegate;
@end
