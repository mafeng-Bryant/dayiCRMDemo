//
//  ActivityDetailViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-9-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ActivityDetailViewCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation ActivityDetailViewCell

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
    lb_participate.text = [NSString stringWithFormat:@"%d人参与 剩余名额:%d",[[data objectForKey:@"joinNumber"] integerValue],[[data objectForKey:@"limitTheNumber"] integerValue]-[[data objectForKey:@"joinNumber"] integerValue]];
    lb_read.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"readNumber"] ];
    lb_share.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"shareNumber"]];
    [im_des setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[data objectForKey:@"pictures"]]];
    
    activityImages = [NSMutableArray arrayWithArray:[data objectForKey:@"activityImages"] ];
    [self setUpScrollView];
    
}

- (void)setUpScrollView
{
    scrollView.contentSize = CGSizeMake([activityImages count]*76, 64);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    for (int i = 0; i < [activityImages count]; i++) {
        NSDictionary *dic = [activityImages objectAtIndex:i];
        ClickImage *img = [[ClickImage alloc] initWithFrame:CGRectMake((12 + 64)*i, 0, 64, 64)];
        img.canClick = YES;
        img.tag = i + 10;
        NSString *avatar_url = [BASE_URL stringByAppendingString:[dic objectForKey:@"pictureId"]];
        UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
        if (avatar_im)
        {
            [img setImage:avatar_im];
        }
        else
        {
            RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                 parentView:img
                                                                   delegate:self
                                                           defaultImageName:@"default_pic_avatar"];
            [img setImage:r_img];
        }
        [scrollView addSubview:img];

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
	
    ClickImage *img = (ClickImage *)[scrollView viewWithTag:[remoteImage.parent_view tag]];
    [img setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
    ClickImage *img = (ClickImage *)[scrollView viewWithTag:[remoteImage.parent_view tag]];
    [img setImage:newImage];
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

@end
