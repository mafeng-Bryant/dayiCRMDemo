//
//  MemberListCell.m
//  dayiCRM
//
//  Created by Fang on 14-4-18.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MemberListCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation MemberListCell
@dynamic avatar,lb_nickname,btn;

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
    if ([[data objectForKey:@"customerName"] length]) {
        lb_nickname.text = [data objectForKey:@"customerName"];
        btn.hidden = YES;
    }
    else{
        lb_nickname.text = [data objectForKey:@"name"];
    }
    if ([[data objectForKey:@"status"] length] == 0) {
        btn.hidden = YES;
    }
   else if ([[data objectForKey:@"status"] integerValue] == 0 || [[data objectForKey:@"status"] length] == 0) {
        [btn setTitle:@"邀请" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([[data objectForKey:@"status"] integerValue] == 1) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn3"] forState:UIControlStateNormal];
        [btn setTitle:@"已邀请" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.enabled = NO;
    }
    else if ([[data objectForKey:@"status"] integerValue] == 2) {
        [btn setTitle:@"已绑定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.enabled = NO;
    }
    
    NSString *avatar_url;
    if ([data objectForKey:@"pictureId"]) {
        avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[data objectForKey:@"pictureId"]];
    }
    else{
        avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[data objectForKey:@"avatarId"]];
    }
    
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
