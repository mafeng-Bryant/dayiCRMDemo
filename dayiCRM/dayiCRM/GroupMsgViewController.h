//
//  GroupMsgViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-9.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendTypeListViewController.h"
#import "LXActionSheet.h"

@interface GroupMsgViewController : UITableViewController<UITextViewDelegate,SendTypeListViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LXActionSheetDelegate>
{
    IBOutlet UIView *footView;
    IBOutlet UIView *entryView;
    
    IBOutlet UITextView *tx_content;
    
    IBOutlet UIButton *btn_img;
    IBOutlet UIButton *btn_pic;
    IBOutlet UIButton *btn_activity;
    IBOutlet UIButton *btn_send;
    
    UILabel *lb_type;
    NSString *type;
    NSString *gid;
    NSString *gName;
    NSData *image_data;
    NSString *pictureId;
    NSString *entityId;

}

@property(nonatomic,copy)NSString *gid;
@property(nonatomic,copy)NSString *gName;


@end
