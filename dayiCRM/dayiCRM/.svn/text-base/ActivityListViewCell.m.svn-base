//
//  ActivityListViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-9-13.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ActivityListViewCell.h"

@implementation ActivityListViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
    if ([[data objectForKey:@"type"] integerValue] == 2) {
        im_point.image = [UIImage imageNamed:@"img50.png"];
        lb_status.text = @"进行中";
        lb_status.textColor = dayiColor;
    }
    else{
        im_point.image = [UIImage imageNamed:@"img51.png"];
        lb_status.textColor = [UIColor lightGrayColor];
        if ([[data objectForKey:@"type"] integerValue] == 1) {
            lb_status.text = @"未开始";
        }
        else{
            lb_status.text = @"已结束";
        }
    }
    
    lb_title.text = [data objectForKey:@"name"];

    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createTime"] doubleValue]/1000]];
    lb_time.text = post_date;
    lb_participate.text = [data objectForKey:@"joinPerson"];
    lb_read.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"readNumber"] ];
    lb_share.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"shareNumber"]];
    [im_des setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[data objectForKey:@"image"]]];
}

@end
