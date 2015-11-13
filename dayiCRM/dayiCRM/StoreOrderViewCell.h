//
//  StoreOrderViewCell.h
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"

@interface StoreOrderViewCell : UITableViewCell
{
    IBOutlet UrlImageView *im_avatar;
    IBOutlet UILabel *lb_productName;
    IBOutlet UILabel *lb_amount;
    IBOutlet UILabel *lb_unitPrice;
    IBOutlet UILabel *lb_totalPrice;
}

- (void) setContent:(NSDictionary *)data;


@end
