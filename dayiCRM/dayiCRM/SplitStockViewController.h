//
//  SplitStockViewController.h
//  dayiCRM
//
//  Created by Fang on 14/10/20.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface SplitStockViewController : UITableViewController<UITextFieldDelegate>
{
    NSDictionary *dataDict;
    UrlImageView *im_avatar;
    UILabel *lb_name;
    NSString *productName;
    UITextField *tf_splitNum;
    
    UILabel *lb_rule;
    
    UILabel *lb_yuankucun;
    UILabel *lb_xinkucun;

    UILabel *lb_yuankucun_unit;
    UILabel *lb_xinkucun_unit;

}

@property(nonatomic,retain)NSDictionary *dataDict;
@property(nonatomic,copy)NSString *productName;

@end
