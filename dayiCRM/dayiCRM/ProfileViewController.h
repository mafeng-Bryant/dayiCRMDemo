//
//  ProfileViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-25.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXActionSheet.h"

@class UrlImageView;

@interface ProfileViewController : UITableViewController<LXActionSheetDelegate>
{
    UrlImageView *im_avatar;
    UILabel *lb_name;
}
@end
