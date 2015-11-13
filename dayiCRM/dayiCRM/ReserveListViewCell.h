//
//  ReserveListViewCell.h
//  dayiCRM
//
//  Created by Leo on 14/11/5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface ReserveListViewCell : UITableViewCell
{
	IBOutlet UrlImageView *im_avatar;
	IBOutlet UILabel *lb_roomName;
	IBOutlet UILabel *lb_name;
	IBOutlet UILabel *lb_mobile;
	IBOutlet UILabel *lb_startTime;
	IBOutlet UILabel *lb_endTime;
}

- (void) setContent:(NSDictionary *)data;

@end
