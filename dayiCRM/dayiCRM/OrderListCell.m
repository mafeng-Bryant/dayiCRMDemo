//
//  OrderListCell.m
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "OrderListCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"

@implementation OrderListCell
@synthesize lb_amount;
@synthesize lb_brandName;
@synthesize lb_executor;
@synthesize lb_price;
@synthesize lb_purchaser;
@synthesize lb_timestamp;
@synthesize avatar;
@synthesize btn;
@synthesize im_status;
@synthesize singleline;
@synthesize lb_orderName;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 100;
}

- (void) setContent:(NSDictionary *)data
{
    if ([data objectForKey:@"productName"]) {
        lb_brandName.text = [NSString stringWithFormat:@"%@ %@",[data objectForKey:@"productName"],[data objectForKey:@"productPici"]];
    }
    else
    {
        lb_brandName.text = [NSString stringWithFormat:@"%@ %@",[data objectForKey:@"name"],[data objectForKey:@"productPici"]];
    }
    if ([[data objectForKey:@"unitName"] length])
    {
        lb_amount.text = [NSString stringWithFormat:@"数量: %@%@",[data objectForKey:@"quantity"],[data objectForKey:@"unitName"]];
    }
    else
        lb_amount.text = [NSString stringWithFormat:@"数量: %@件",[data objectForKey:@"offerPieceQty"]];
    
    lb_executor.text = [NSString stringWithFormat:@"执行人:%@",[data objectForKey:@"executeUserId"]];
    if ([data objectForKey:@"detailAmount"]) {
        lb_price.text =[NSString stringWithFormat:@"总价: ￥%@",[data objectForKey:@"detailAmount"]];
    }
    else
    {
        lb_price.text =[NSString stringWithFormat:@"总价: ￥%@",[data objectForKey:@"receivableAmount"]];
    }
    lb_purchaser.text =[NSString stringWithFormat:@"下单人:%@",[data objectForKey:@"userId"]];
    lb_orderName.text = [NSString stringWithFormat:@"订单编号:%@",[data objectForKey:@"orderName"]];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *post_date;
    if ([data objectForKey:@"createTime"]) {
        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createTime"] doubleValue]/1000]];
    }
    else
    {
        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"crateTime"] doubleValue]/1000]];
    }
    lb_timestamp.text = [NSString stringWithFormat:@"下单时间:%@",post_date];

    if (![[data objectForKey:@"status"] length] ) {
        self.btn.hidden = YES;
    }
    else if ([[data objectForKey:@"type"] integerValue] == 1 && [[data objectForKey:@"status"] isEqualToString:@"Finished"]) {
        im_status.image = [UIImage imageNamed:@"yjz"];
    }
    else if ([[data objectForKey:@"type"] integerValue] == 1)
    {
        im_status.image = [UIImage imageNamed:@"wjz"];
    }
    else
    {
        if ([[data objectForKey:@"status"] isEqualToString:@"New"]) {
            im_status.image = [UIImage imageNamed:@"order_New"];
        }
        else if ([[data objectForKey:@"status"] isEqualToString:@"Unconfirmed"])
        {
            im_status.image = [UIImage imageNamed:@"order_uncomfired"];
        }
        else if ([[data objectForKey:@"status"] isEqualToString:@"Confirmed"])
        {
            if ([[data objectForKey:@"payStatus"] isEqualToString:@"UnPay"]) {
                im_status.image = [UIImage imageNamed:@"order_Confirmed"];
            }
            else if ([[data objectForKey:@"payStatus"] isEqualToString:@"Paying"]){
                im_status.image = [UIImage imageNamed:@"fkz"];
            }
            else if ([[data objectForKey:@"payStatus"] isEqualToString:@"Payed"]){
                im_status.image = [UIImage imageNamed:@"yfk"];
            }
            else if ([[data objectForKey:@"payStatus"] isEqualToString:@"Transfer"]){
                im_status.image = [UIImage imageNamed:@"yzz"];
            }
        }
        else if ([[data objectForKey:@"status"] isEqualToString:@"Finished"])
        {
            im_status.image = [UIImage imageNamed:@"order_Finished"];
        }
        else if ([[data objectForKey:@"status"] isEqualToString:@"Canceled"])
        {
            [btn setTitle:@"已取消" forState:UIControlStateNormal];
            im_status.image = [UIImage imageNamed:@"order_canceled"];

        }
     }
    
    singleline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"singleLine"]];
    singleline.frame = CGRectMake(0, 50, 320, 1);
    
    if (!IOS7)
    {
        singleline.frame = CGRectMake(0, 50, 300, 1);

        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 142);
        [self.contentView insertSubview:messageBackgroundView atIndex:0];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }
    
    [self.contentView addSubview:singleline];
    
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
