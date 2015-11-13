//
//  OrderStoreDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBController.h"
#import "ISSCTableAlertView.h"

@interface OrderStoreDetailViewController :CBController <UITableViewDataSource,UITableViewDelegate,TableAlertViewDelegate>
{
    NSString *oid;
    NSUInteger type;
    UIView  *footView;
    NSDictionary *dict;
    NSArray *detailArray;
    NSMutableArray *buffer;
    
    UILabel *lb_detailAmount;
    UILabel *lb_roomName;
    UILabel *lb_roomPrice;
    UILabel *lb_roomHour;
    UILabel *lb_perHourPrice;
    
    UILabel *lb_discount;
    MyPeripheral *connectedPeripheral;
    BOOL writeAllowFlag;
    long fileReadOffset;
    
    ISSCTableAlertView *alertView;

}

@property(nonatomic,copy)NSString *oid;
@property(nonatomic,assign)NSUInteger type;

@end
