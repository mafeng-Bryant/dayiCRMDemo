//
//  ActivityListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-13.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityListViewController;

@protocol ActivityListViewControllerDelegate <NSObject>

- (void)activityListViewControllerDidSelected:(NSDictionary *)activity;

@end

@interface ActivityListViewController : UITableViewController
{
    NSMutableArray *buffer;
    
   __weak id<ActivityListViewControllerDelegate>delegate;
    

}

@property (nonatomic,weak)id<ActivityListViewControllerDelegate>delegate;;
@end
