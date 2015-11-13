//
//  AddAuthViewController.h
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface AddAuthViewController : UITableViewController<UITextFieldDelegate>
{
    NSString *authId;
    
    UITextField *tf_realName;
    UITextField *tf_bankCard;
    UITextField *tf_idCard;
    
    UrlImageView *im_idCardY;
    NSString *idCardYId;
    UrlImageView *im_idCardN;
    NSString *idCardNId;
    UrlImageView *im_copyOfBankCard;
    NSString *copyOfBankCardId;
    NSDictionary *dataDict;
    
    NSUInteger pictureType;
    UIActionSheet                   *actionSheet;

}

@property(nonatomic,copy)NSString *authId;

@end
