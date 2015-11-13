//
//  GroupListViewCell.h
//  dayiCRM
//
//  Created by Fang on 14-9-9.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface GroupListViewCell : UITableViewCell
{
    IBOutlet UrlImageView *img;
    IBOutlet UILabel *lb_title;
    IBOutlet UILabel *lb_time;
}

- (void) setContent:(NSDictionary *)data;

@end
