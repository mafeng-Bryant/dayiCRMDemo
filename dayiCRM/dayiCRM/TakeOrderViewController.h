//
//  TakeOrderViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-2.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListViewController.h"
#import "PriceListViewController.h"
#import "MemberUsrListViewController.h"

@interface TakeOrderViewController : UITableViewController<UITextFieldDelegate,ProductListViewControllerDelegate,PriceListViewControllerDelegate,MemberUsrListViewControllerDelegate>
{
    UITextField *tf_total;
    NSString *total;
    UITextField *tf_address;
    NSString *address;
    UITextField *tf_tel;
    NSString *tel;
    UITextField *tf_remark;
    NSString *remark;
    UITextField *tf_discount;
    NSString *discount;

    UILabel *lb_amount;
    NSString *amount;
    UILabel *lb_orderer;
    NSString *order;
    NSString *orderId;
    UILabel *lb_add;
    
    NSUInteger productNum;
    NSUInteger seletedIndex;
    
    NSString *productsString;
    NSMutableArray *productArray;
    NSString *oid;
    
    IBOutlet UIToolbar *tool_bar;
    IBOutlet UIButton *btn_total_price;
    IBOutlet UIButton *btn_certain;

}
@end
