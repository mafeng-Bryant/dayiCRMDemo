//
//  HistoryListViewController.h
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryListViewController : UITableViewController
{
	NSMutableArray *buffer;
	NSString *applyUser;
}

@property(nonatomic,copy)NSString *applyUser;

@end
