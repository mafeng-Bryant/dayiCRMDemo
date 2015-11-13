//
//  ChannelManagerListViewCell.m
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ChannelManagerListViewCell.h"

@implementation ChannelManagerListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
	lb_name.text = [NSString stringWithFormat:@"申请人:%@",[data objectForKey:@"name"]];
	NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createTime"] doubleValue]/1000]];
	lb_time.text = [@"申请时间:" stringByAppendingString:post_date];
	if ([[data objectForKey:@"type"] integerValue] == 1) {
		lb_type.text = @"兼职业务员";
	}
	else{
		lb_type.text = @"代理商";
	}

	if([[data objectForKey:@"auditState"] integerValue] == 1) {
		im_status.image = [UIImage imageNamed:@"img80.png"];
	}
	else if([[data objectForKey:@"auditState"] integerValue] == 2) {
		im_status.image = [UIImage imageNamed:@"img81.png"];
	}
	else{
		im_status.alpha = 0.0f;
	}
}

@end
