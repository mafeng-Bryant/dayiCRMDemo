//
//  GroupListViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-9-9.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "GroupListViewCell.h"

@implementation GroupListViewCell

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
    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 50.0f);
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }

    lb_title.text = [data objectForKey:@"name"];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createTime"] doubleValue]/1000]];
    lb_time.text = post_date;
    [img setImageWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:[data objectForKey:@"image"]] ] placeholderImage:[UIImage imageNamed:@"img56"]];
}

@end
