//
//  StockTreeViewCell.m
//  dayiCRM
//
//  Created by Fang on 14-6-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockTreeViewCell.h"

@implementation StockTreeViewCell
@synthesize lb_year;
@synthesize im_triangle;
@synthesize treeNode;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpTitleLableAndImg
{
    if ([self.treeNode.nodeObject isKindOfClass:[NSString class]]) {
        self.lb_year.text = self.treeNode.nodeObject;
    }
    else{
        NSDictionary *dic = (NSDictionary *)self.treeNode.nodeObject;
        self.lb_year.text = [dic objectForKey:@"yearName"];
    }
    self.im_triangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expandableImage.png"]];
    self.im_triangle.frame = CGRectMake(292, 18, 8, 5);
    if (self.treeNode.isExpanded) {
        [self rotateArrow:M_PI];
    }
    else{
        [self rotateArrow:0];
    }
    
    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44.0f);
        [self.contentView insertSubview:messageBackgroundView atIndex:0];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
        self.im_triangle.frame = CGRectMake(270, 18, 8, 5);
    }

    if ([self.treeNode.nodeChildren count])
        [self.contentView addSubview:self.im_triangle];

}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.im_triangle.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

@end
