//
//  ContactsListViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-9-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ContactsListViewCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation ContactsListViewCell

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
    return 55;
}

- (void) setContent:(NSDictionary *)data
{
    lb_nickname.text = [data objectForKey:@"customerName"];

    NSString *avatar_url;
    avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[data objectForKey:@"pictureId"]];
    
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
    
    if ([[data objectForKey:@"selected"]integerValue]) {
        [checkIcon setImage:[UIImage imageNamed:@"img48"]];
    }
    else{
        [checkIcon setImage:[UIImage imageNamed:@"img47"]];

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
