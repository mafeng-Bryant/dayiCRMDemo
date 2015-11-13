//
//  MemberListCell.h
//  dayiCRM
//
//  Created by Fang on 14-4-18.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberListCell : UITableViewCell
{
   IBOutlet UIImageView *avatar;
   IBOutlet UILabel *lb_nickname;
   IBOutlet UIButton *btn;
}

@property(nonatomic,strong)UIImageView *avatar;
@property(nonatomic,strong)UILabel *lb_nickname;
@property(nonatomic,strong)UIButton *btn;

+ (CGFloat) calCellHeight:(NSDictionary *)data;

- (void) setContent:(NSDictionary *)data;

@end
