//
//  ChannelManagerListViewCell.h
//  dayiCRM
//
//  Created by Leo on 14/11/4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelManagerListViewCell : UITableViewCell
{
	IBOutlet UILabel *lb_name;
	IBOutlet UIImageView *im_status;
	IBOutlet UILabel *lb_time;
	IBOutlet UILabel *lb_type;
}

- (void) setContent:(NSDictionary *)data;

@end
