//
//  ExecutorListCell.m
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ExecutorListCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation ExecutorListCell
@synthesize avatar,lb_address,lb_name,lb_porticus;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc
{
    avatar=nil;
    lb_address=nil;
    lb_name=nil;
    lb_porticus=nil;
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 55;
}
- (void) setContent:(NSDictionary *)data
{
    lb_porticus.text = [data objectForKey:@"storeName"];
    lb_name.text = [data objectForKey:@"name"];
    lb_address.text = [data objectForKey:@"address"];
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
