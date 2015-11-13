//
//  AuthListViewCell.h
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
@interface AuthListViewCell : UITableViewCell
{
    IBOutlet UILabel *lb_usrName;
    IBOutlet UILabel *lb_realName;
    IBOutlet UILabel *lb_cardNo;
    IBOutlet UILabel *lb_bankCard;
    IBOutlet UIImageView *im_status;
    IBOutlet UrlImageView *im_avatar;

}

- (void) setContent:(NSDictionary *)data;

@end
