//
//  ReserveListViewCell.m
//  dayiCRM
//
//  Created by Leo on 14/11/5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ReserveListViewCell.h"

@implementation ReserveListViewCell

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
	lb_roomName.text = [data objectForKey:@"roomName"];
	lb_name.text = [@"联系人:"stringByAppendingString:[data objectForKey:@"name"] ];
	lb_mobile.text = [data objectForKey:@"mobile"];
	
	NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"startTime"] doubleValue]/1000]];
	NSString *end_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"endTime"] doubleValue]/1000]];
	lb_startTime.text = [@"开始:"stringByAppendingString:start_date];
	lb_endTime.text = [@"结束:"stringByAppendingString:end_date];

}

@end
