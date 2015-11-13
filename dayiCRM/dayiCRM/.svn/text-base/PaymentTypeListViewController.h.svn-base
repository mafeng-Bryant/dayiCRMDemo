//
//  PaymentTypeListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-7-24.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentTypeListViewController;

@protocol PaymentTypeListViewControllerDelegate <NSObject>

- (void)PaymentTypeListViewController:(PaymentTypeListViewController *)ctrl didSelectedIndex:(NSUInteger)index;

@end


@interface PaymentTypeListViewController : UITableViewController
{
    __weak id <PaymentTypeListViewControllerDelegate>srcDelegate;
    NSArray *buffer;
}

@property (nonatomic,weak)id <PaymentTypeListViewControllerDelegate>srcDelegate;
@property (nonatomic,retain)NSArray *buffer;

- (void)setUpBuffer:(NSArray *)arrary;

@end
