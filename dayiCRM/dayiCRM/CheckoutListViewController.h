//
//  CheckoutListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
#import "LXActionSheet.h"
#import "PaymentTypeListViewController.h"

@interface CheckoutListViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,LXActionSheetDelegate,PaymentTypeListViewControllerDelegate>
{
    IBOutlet UIView *head_view;
    IBOutlet UILabel *lb_orderName;
    IBOutlet UILabel *lb_userName;
    IBOutlet UILabel *lb_time;
    IBOutlet UrlImageView *im_avatar;
    IBOutlet UILabel *lb_paymentType;

    NSString *paymentType;
    NSArray *payArray;
    NSDictionary *dict;
    UIView *footView;
    NSString *oid;
    
    UILabel *lb_detailAmount;
    UILabel *lb_roomName;
    UILabel *lb_roomPrice;
    UILabel *lb_roomHour;
    UILabel *lb_perHourPrice;
    
    UITextField *tf_discount;
    UILabel *lb_totalAmount;
    NSString *roomId;
    NSArray *roomArray;
    NSUInteger srcType;
    UIToolbar					*tool_bar;
	UIBarButtonItem				*btn_cancel;
	UIBarButtonItem				*btn_certain;
    UIBarButtonItem             *btn_title;
    UIActionSheet               *actionSheet;


}

@property(nonatomic,copy)NSString *oid;

@end
