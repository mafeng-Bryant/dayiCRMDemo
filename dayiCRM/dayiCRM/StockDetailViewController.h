//
//  StockDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailViewController : UIViewController
{
    NSMutableArray *buffer;
    NSDictionary *detailDic;
    NSDictionary *historyDic;
    NSString *sid;
    NSString *title_name;
    BOOL is_history;
}

@property(nonatomic,copy)NSString *sid;
@property(nonatomic,copy)NSString *title_name;

@end
