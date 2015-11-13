//
//  ChannelManagerDetaiViewCell.m
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ChannelManagerDetaiViewCell.h"

@implementation ChannelManagerDetaiViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
	if ([[data objectForKey:@"type"] integerValue] == 1) {
		lb_type.text = @"兼职业务员";
	}
	else{
		lb_type.text = @"代理商";
	}
	lb_mobileNo.text = [data objectForKey:@"mobile"];
	lb_qq.text = [data objectForKey:@"qq"];
	lb_cardNo.text = [data objectForKey:@"cardNo"];

}

@end
