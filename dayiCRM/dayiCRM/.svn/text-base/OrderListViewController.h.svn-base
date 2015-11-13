//
//  OrderListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "DropDownChooseProtocol.h"

@interface OrderListViewController : UITableViewController<DropDownChooseDelegate,DropDownChooseDataSource>
{
    NSMutableArray *buffer;
    NSUInteger  pageIndex;
    NSUInteger  pageCount;
    NSUInteger  type;
    UIButton *btn1;
    UIButton *btn2;
    BOOL is_confirmed;
    EGORefreshTableHeaderView	*refreshHeaderView_bottom;

}

@property(nonatomic,assign)NSUInteger  type;

- (void)loadData;

@end
