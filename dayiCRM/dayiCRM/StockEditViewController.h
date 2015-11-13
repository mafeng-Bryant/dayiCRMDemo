//
//  StockEditViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockEditViewController : UITableViewController<UITextFieldDelegate>
{
    UITextField *tf_rate;
    UITextField *tf_reveal;
    UITextField *tf_bid;
    UITextField *tf_quote;
    UITextField *tf_abid;
    
    UITextField *tf_rate_b;
    UITextField *tf_reveal_b;
    UITextField *tf_bid_b;
    UITextField *tf_quote_b;
    UITextField *tf_abid_b;

    NSString *title_name;
    NSString *productId;
    NSMutableDictionary *dict;
}

@property(nonatomic,copy)NSString *title_name;
@property(nonatomic,copy)NSString *productId;

@property(nonatomic,retain)NSDictionary *dict;

@end
