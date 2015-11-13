//
//  StockCheckViewController.h
//  dayiCRM
//
//  Created by Fang on 14/10/22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface StockCheckViewController : UITableViewController<UITextFieldDelegate>
{
    NSDictionary *dataDict;
    UrlImageView *im_avatar;
    UILabel *lb_name;
    NSString *productName;
    UITextField *tf_checkJian;
    UITextField *tf_checkUnit;
    UITextField *tf_remark;

    UILabel *lb_originalJian;
    UILabel *lb_originalUnit;
    UILabel *lb_checkResult;
    
    UILabel *lb_originalBig;
    UILabel *lb_originalSmall;
    UILabel *lb_checkBig;
    UILabel *lb_checkSmall;
    NSString *result;
    NSString *reportId;
    BOOL    isUnCheck;
}

@property(nonatomic,retain)NSDictionary *dataDict;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *result;
@property(nonatomic,copy)NSString *reportId;
@property(nonatomic,assign)BOOL    isUnCheck;

@end
