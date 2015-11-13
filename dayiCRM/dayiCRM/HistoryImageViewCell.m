//
//  HistoryImageViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-9-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "HistoryImageViewCell.h"

@implementation HistoryImageViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
    NSString *content = [data  objectForKey:@"sendContent"];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
    CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(234, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    if (actualsize.height + 33 > 90) {
        return  actualsize.height + 33 + 10;

    }
    return  90;
}

- (void) setContent:(NSDictionary *)data
{
    lb_name.text = [data objectForKey:@"sendUserName"];
    if ([[data objectForKey:@"msgType"] isEqualToString:@"weixin"]) {
        lb_type.text = @"微信";
    }
    else{
        lb_type.text = @"短信";
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"YY-MM-dd HH:MM"];
    
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"sendTime"] doubleValue]/1000]];
        lb_time.text = post_date;
    
    send_img.canClick = YES;
    NSString *avatar_ur = [BASE_URL stringByAppendingString:[data objectForKey:@"sendImage"]];
    UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_ur];
    if (avatar_im)
    {
        [send_img setImage:avatar_im];
    }
    else
    {
        RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_ur
                                                             parentView:send_img
                                                               delegate:self
                                                       defaultImageName:@"default_pic_avatar"];
        [send_img setImage:r_img];
    }

    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
    NSString *content = [data  objectForKey:@"sendContent"];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
    CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(234, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    lb_content = [[UILabel alloc] initWithFrame:CGRectMake(66, 33, 234, actualsize.height)];
    lb_content.font = fnt;
    lb_content.textColor = [UIColor blackColor];
    lb_content.text = content;
    lb_content.numberOfLines = 0;
    lb_content.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:lb_content];

}

#pragma mark -
#pragma mark RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	static UIImage *empty_image = nil;
	
	if (nil == empty_image)
	{
		empty_image = [UIImage imageNamed:@"default_pic_avatar"];
	}
	
    [send_img setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
    [send_img setImage:newImage];
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}


@end
