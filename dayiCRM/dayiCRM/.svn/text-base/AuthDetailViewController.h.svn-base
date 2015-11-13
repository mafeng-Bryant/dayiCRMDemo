//
//  AuthDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
#import "ClickImage.h"

@interface AuthDetailViewController : UITableViewController
{
    IBOutlet UIView *head_view;
    IBOutlet UrlImageView *im_avatar;
    IBOutlet UILabel *lb_name;
    IBOutlet UILabel *lb_time;
    IBOutlet UIImageView *im_status;
    
    IBOutlet UIView *foot_view;
    IBOutlet UIButton *btn_pass;
    IBOutlet UIButton *btn_unpass;
    NSDictionary *dataDic;
    NSString *applyStatus;
    
    ClickImage *idCardYImage;
    ClickImage *idCardNImage;
    ClickImage *copyOfBankCardImage;
    
    NSString *authId;

}

@property(nonatomic,copy)NSString *authId;

@property(nonatomic,copy)NSString *chuckStatus;

@end
