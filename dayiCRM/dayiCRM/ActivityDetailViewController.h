//
//  ActivityDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"

@interface ActivityDetailViewController : UITableViewController<LXActionSheetDelegate>
{
    NSDictionary *dataDict;
    NSString *aid;
    UIButton *edit;
    NSMutableArray *activityImages;
    NSMutableArray *activeRecords;
    UILabel *lb_des;
    UILabel *lb_time;
    UILabel *lb_address;
    UILabel *lb_sponsor;
    UILabel *lb_participation;

}

@property(nonatomic,copy)NSString *aid;

@end
