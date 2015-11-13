//
//  ExecutorListCell.h
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExecutorListCell : UITableViewCell
{
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *lb_name;
    IBOutlet UILabel *lb_porticus;
    IBOutlet UILabel *lb_address;
}

@property(nonatomic,strong)UIImageView *avatar;
@property(nonatomic,strong)UILabel *lb_name;
@property(nonatomic,strong)UILabel *lb_porticus;
@property(nonatomic,strong)UILabel *lb_address;

+ (CGFloat) calCellHeight:(NSDictionary *)data;
- (void) setContent:(NSDictionary *)data;

@end
