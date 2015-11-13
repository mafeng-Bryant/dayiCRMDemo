//
//  ProfileDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14-10-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UrlImageView;

@interface ProfileDetailViewController : UITableViewController
{
    UrlImageView *im_avatar;
    UILabel *lb_name;
    UILabel *lb_loginName;
    UILabel *lb_tel;
    UILabel *lb_gender;
    UILabel *lb_region;
    
    NSDictionary *dict;

}
@end
