//
//  EditActivityViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageButton.h"


@interface EditActivityViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView *head_view;
    IBOutlet UITextField *tf_title;
    IBOutlet UITextView *tv_des;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *lb_placeholder;

    IBOutlet UrlImageButton *btn_avatar;

    NSMutableArray *activityImages;
    NSMutableArray *orignalImages;

    NSMutableArray *addImages;
    NSMutableArray *delImages;
    
    NSString *activityPicture;
    NSString *startTime;
    NSString *endTime;
    UITextField *tf_address;
    UITextField *tf_sponsor;
    UITextField *tf_limitTheNumber;
    UITextView *tx_participation;
    UIButton *btn_start ;
    UIButton *btn_end;
    UIImageView *im_sigleLine;
    UIImage *activityImage;
    NSDictionary *dataDict;
    
    NSString *picturesId;
    NSUInteger pictureType;
    NSString *entityId;
    
    UIToolbar                       *tool_bar_tmp;
    UIBarButtonItem                 *btn_certain_tmp;
    UIBarButtonItem                 *btn_cancel;
    UIBarButtonItem                 *btn_title;
    UIActionSheet                   *actionSheet;
    
    NSUInteger timeType;

}

@property(nonatomic,retain)NSDictionary *dataDict;

@end
