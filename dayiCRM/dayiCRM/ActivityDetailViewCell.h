//
//  ActivityDetailViewCell.h
//  dayiCRM
//
//  Created by Fang on 14-9-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
#import "ClickImage.h"

@interface ActivityDetailViewCell : UITableViewCell
{
    IBOutlet UIImageView *im_point;
    IBOutlet UILabel *lb_title;
    IBOutlet UILabel *lb_status;
    IBOutlet UILabel *lb_participate;
    IBOutlet UILabel *lb_share;
    IBOutlet UILabel *lb_read;
    IBOutlet UrlImageView *im_des;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *activityImages;
}

- (void) setContent:(NSDictionary *)data;


@end
