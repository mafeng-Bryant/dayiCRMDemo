//
//  EditProfileViewController.h
//  dayiCRM
//
//  Created by Fang on 14-10-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
#import "ConditionSelectedViewController.h"

@class UrlImageView;

@interface EditProfileViewController : UITableViewController<UITextFieldDelegate,LXActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ConditionSelectedViewControllerDelegate>
{
    NSDictionary *dict;
    NSData *avatar_data;
    NSString *avatarId;
    UITextField *tf_name;
    UITextField *tf_mobile;
    UILabel *lb_gender;
    NSString *gender;
    UILabel *lb_region;
    NSUInteger selectedIndex;
    NSArray *conditionArray;
    UrlImageView *im_avatar;
}

@property(nonatomic,retain)NSDictionary *dict;

@end
