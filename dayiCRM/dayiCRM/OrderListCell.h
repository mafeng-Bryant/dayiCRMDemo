//
//  OrderListCell.h
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell
{
    IBOutlet UILabel *lb_brandName;
    IBOutlet UIImageView *avatar;
    IBOutlet UIImageView *singleline;
    IBOutlet UIImageView *im_status;

    IBOutlet UILabel *lb_purchaser;
    IBOutlet UILabel *lb_executor;
    IBOutlet UILabel *lb_amount;
    IBOutlet UILabel *lb_price;
    IBOutlet UILabel *lb_timestamp;
    IBOutlet UILabel *lb_orderName;

    IBOutlet UIButton *btn;
}

@property(nonatomic,strong)UILabel *lb_brandName;
@property(nonatomic,strong)UILabel *lb_purchaser;
@property(nonatomic,strong)UILabel *lb_executor;
@property(nonatomic,strong)UILabel *lb_amount;
@property(nonatomic,strong)UILabel *lb_price;
@property(nonatomic,strong)UILabel *lb_timestamp;
@property(nonatomic,strong)UILabel *lb_orderName;
@property(nonatomic,strong)UIImageView *avatar;
@property(nonatomic,strong)UIImageView *singleline;
@property(nonatomic,strong)UIImageView *im_status;

@property(nonatomic,strong)UIButton *btn;

+ (CGFloat) calCellHeight:(NSDictionary *)data;
- (void) setContent:(NSDictionary *)data;


@end
