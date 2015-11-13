//
//  MsgListCell.m
//  dayiCRM
//
//  Created by Fang on 14-4-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MsgListCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation MsgListCell
@synthesize avatar,im_newNotify,lb_detail,
lb_nickname,lb_newNotify,lb_time,sigleLine;

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 50;
}

- (void) setContent:(NSDictionary *)data
{
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[data objectForKey:@"avatarId"]];
	UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
	if (avatar_im)
	{
		[avatar setImage:avatar_im];
	}
	else
	{
		RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
															 parentView:avatar
															   delegate:self
													   defaultImageName:@"default_pic_avatar"];
		
		[avatar setImage:r_img];
	}
    
    lb_nickname.text = [data objectForKey:@"name"];
    if ([[data objectForKey:@"msgType"] isEqualToString:@"voice"]) {
        lb_detail.text = @"[语音]";
    }
    else if ([[data objectForKey:@"msgType"] isEqualToString:@"image"]) {
        lb_detail.text = @"[图片]";
    }
    else if ([[data objectForKey:@"msgType"] isEqualToString:@"event"]){
        lb_detail.text = @"[事件]";
    }
    else
    {
        lb_detail.text = [data objectForKey:@"content"];
    }

    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createTime"] doubleValue]/1000]];
    lb_time.text = post_date;
    
    if ([[data objectForKey:@"newcount"] count] == 0 || ![data objectForKey:@"newcount"]) {
        im_newNotify.hidden = YES;
        lb_newNotify.hidden = YES;
    }
    else
    {
        lb_newNotify.text = [data objectForKey:@"newcount"];
    }
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
	
	[avatar setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	[avatar setImage:newImage];
	
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}



@end
