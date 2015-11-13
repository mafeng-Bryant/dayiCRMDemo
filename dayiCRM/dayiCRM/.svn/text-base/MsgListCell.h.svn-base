//
//  MsgListCell.h
//  dayiCRM
//
//  Created by Fang on 14-4-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgListCell : UITableViewCell
{
    IBOutlet UIImageView *avatar;
    IBOutlet UIImageView *im_newNotify;
    IBOutlet UIImageView *sigleLine;

    IBOutlet UILabel *lb_nickname;
    IBOutlet UILabel *lb_detail;
    IBOutlet UILabel *lb_newNotify;
    IBOutlet UILabel *lb_time;

}

@property(nonatomic,strong)UIImageView *avatar;
@property(nonatomic,strong)UIImageView *im_newNotify;
@property(nonatomic,strong)UIImageView *sigleLine;
@property(nonatomic,strong)UILabel *lb_nickname;
@property(nonatomic,strong)UILabel *lb_detail;
@property(nonatomic,strong)UILabel *lb_newNotify;
@property(nonatomic,strong)UILabel *lb_time;


+ (CGFloat) calCellHeight:(NSDictionary *)data;

- (void) setContent:(NSDictionary *)data;

@end
