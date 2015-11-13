//
//  ReserveDetailViewController.h
//  dayiCRM
//
//  Created by Leo on 14/11/5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
#import "ExecutorListViewController.h"
//typedef NS_ENUM(NSUInteger, SrcType) {
//    //包间预订
//    kSrcTypeSure = 0,
//	//包间详情
//    kSrcTypeDetail,
//};
@interface ReserveDetailViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,ExecutorListViewDelegate>
{
	IBOutlet UIView *head_view;
	IBOutlet UrlImageView *im_avatar;
	IBOutlet UILabel *lb_roomName;
	IBOutlet UILabel *lb_roomPrice;
	
	IBOutlet UIView *footView;
	IBOutlet UIButton *btn_submit;
	
	NSUInteger srcType;
	NSDictionary *dataDic;
	
	UILabel *lb_startTime;
	NSString *startTime;
	UILabel *lb_endTime;
	NSString *endTime;
	
	UITextField *tf_contact;
	UITextField *tf_mobile;
	UITextField *tf_remark;
	
	UILabel *lb_reserveUser;
	NSString *reserveUserId;
	NSString *reserveId;
    
    UIToolbar                       *tool_bar_tmp;
    UIBarButtonItem                 *btn_certain_tmp;
    UIBarButtonItem                 *btn_cancel_tmp;
    UIBarButtonItem                 *btn_title;
    UIActionSheet                   *actionSheet;
    NSUInteger type;

}

@property(nonatomic,assign)NSUInteger srcType;
@property(nonatomic,copy)NSString *reserveId;
@property(nonatomic,retain)NSDictionary *dataDic;

@end
