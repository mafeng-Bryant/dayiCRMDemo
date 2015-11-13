//
//  StockCheckReportViewController.h
//  dayiCRM
//
//  Created by Fang on 14/10/23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"

@interface StockCheckReportViewController : UITableViewController<LXActionSheetDelegate>
{
    NSMutableArray *buffer;
    NSString *reportId;
    NSDictionary *dataDict;
    UIButton *btn_del;
}

@property(nonatomic,copy)NSString *reportId;
@property(nonatomic,retain)NSDictionary *dataDict;

@end
