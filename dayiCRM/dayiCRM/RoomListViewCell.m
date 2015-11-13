//
//  RoomListViewCell.m
//  dayiCRM
//
//  Created by Leo on 14/11/5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "RoomListViewCell.h"

@implementation RoomListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
	[im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[data objectForKey:@"avatarId"]]];
	lb_name.text = [data objectForKey:@"roomName"];
	lb_price.text = [NSString stringWithFormat:@"￥%@/小时",[data objectForKey:@"perHourPrice"]];
}

@end
