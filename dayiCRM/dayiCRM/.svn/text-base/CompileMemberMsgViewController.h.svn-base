//
//  CompileMemberMsgViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
#import "QCheckBox.h"
#import "AgeGroupViewController.h"
@protocol CompileMemberMsgDelegate<NSObject>
@optional
- (void)compileMemberMsgViewDidAdd:(NSDictionary *)dic;
@end

@interface CompileMemberMsgViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate,LXActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,QCheckBoxDelegate,AgeGroupViewControllerDelegate>
{
    UIImageView *avatar;
    UITextField *tf_nickname;
    UITextField *tf_name;

    UITextField *tf_telnumber;
    UITextView *tv_remark;
    UITextField *tf_address;
    UITextField *active_tf;

    UITextField *tf_email;
    UITextField *tf_sinaWeibo;
    UITextField *tf_qqWeibo;

    UILabel *lb_age;
    
    NSString *avatarId;
    NSString *ageGroup;
    NSDictionary *dict;
    NSData *data_avatar;
    QCheckBox *femal_box;
    QCheckBox *male_box;
    NSString *gender;
    
    __weak id<CompileMemberMsgDelegate>delegate;
}

@property(nonatomic,retain)NSDictionary *dict;
@property(nonatomic,weak) id<CompileMemberMsgDelegate>delegate;


@end
