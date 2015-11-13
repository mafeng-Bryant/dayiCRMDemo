//
//  AuthDetailViewCell.h
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthDetailViewCell : UITableViewCell
{
    IBOutlet UILabel *lb_realName;
    IBOutlet UILabel *lb_idCardNo;
    IBOutlet UILabel *lb_bankNo;

}

- (void) setContent:(NSDictionary *)data;

@end
