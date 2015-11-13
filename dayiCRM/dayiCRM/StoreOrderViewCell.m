//
//  StoreOrderViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StoreOrderViewCell.h"

@implementation StoreOrderViewCell

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
    lb_productName.text = [data objectForKey:@"productName"];
    lb_amount.text = [[data objectForKey:@"productNumber"]stringByAppendingString:[data objectForKey:@"unitName"]];
    lb_unitPrice.text = [@"￥"stringByAppendingString:[data objectForKey:@"unitPrice"]];
    lb_totalPrice.text = [NSString stringWithFormat:@"￥%.2f",[[data objectForKey:@"unitPrice"] floatValue]*[[data objectForKey:@"productNumber"] floatValue]];
    [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[data objectForKey:@"productStorePicture"]]];

    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 76);
        [self.contentView insertSubview:messageBackgroundView atIndex:0];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }

}


@end
