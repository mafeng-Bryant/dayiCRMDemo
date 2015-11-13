//
//  passwordSetViewController.h
//  dayiCRM
//
//  Created by Fang on 14-10-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface passwordSetViewController : UITableViewController<UITextFieldDelegate>
{
    UILabel *lb_account;
    UITextField *tf_currentPassword;
    UITextField *tf_newPassword;
    UITextField *tf_confirmPassword;
}


@end
