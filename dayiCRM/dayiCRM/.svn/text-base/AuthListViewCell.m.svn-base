//
//  AuthListViewCell.m
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AuthListViewCell.h"

@implementation AuthListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
    if([[data objectForKey:@"auditState"] integerValue] == 1) {
        im_status.image = [UIImage imageNamed:@"img80.png"];
    }
    else if([[data objectForKey:@"auditState"] integerValue] == 2) {
        im_status.image = [UIImage imageNamed:@"img81.png"];
    }
    else{
        im_status.alpha = 0.0f;
    }
    
    lb_usrName.text = [@"认证人:"stringByAppendingString:[data objectForKey:@"userName"] ];
    lb_realName.text = [data objectForKey:@"realName"];
    lb_cardNo.text = [data objectForKey:@"cardNo"];
    lb_bankCard.text = [data objectForKey:@"bankCard"];
	
 NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[data objectForKey:@"avatarId"]];
	
	NSLog(@"avatar_url = %@",avatar_url);
	
	
    [im_avatar setImageFromUrl:YES withUrl:avatar_url];
	
}

@end
