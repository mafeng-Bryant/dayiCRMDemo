//
//  SystemMsgViewCell.m
//  dayiCRM
//
//  Created by Fang on 14/10/24.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "SystemMsgViewCell.h"

@implementation SystemMsgViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:14.0f];
    NSString *content = [data objectForKey:@"content"];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
    CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(297, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height + 65;
}

- (void) setContent:(NSDictionary *)data
{
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:14.0f];
    NSString *content = [data objectForKey:@"content"];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
    CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(297, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    lb_content = [[UILabel alloc] initWithFrame:CGRectMake(8, 55, 297, actualsize.height)];
    lb_content.font = fnt;
    lb_content.textColor = [UIColor blackColor];
    lb_content.text = content;
    lb_content.numberOfLines = 0;
    lb_content.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:lb_content];
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM"];
    NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"sendTime"] doubleValue]/1000]];

    lb_time.text =  start_date;
    
    lb_title.text = [data objectForKey:@"subject"];
}

@end
