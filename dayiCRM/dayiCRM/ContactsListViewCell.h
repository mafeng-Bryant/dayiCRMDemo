//
//  ContactsListViewCell.h
//  dayiCRM
//
//  Created by Fang on 14-9-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsListViewCell : UITableViewCell
{
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *lb_nickname;
    IBOutlet UIImageView *checkIcon;
}

+ (CGFloat) calCellHeight:(NSDictionary *)data;

- (void) setContent:(NSDictionary *)data;

@end
