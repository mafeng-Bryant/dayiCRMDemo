//
//  SendTypeListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendTypeListViewController;

@protocol SendTypeListViewControllerDelegate <NSObject>

- (void)sendTypeListViewController:(SendTypeListViewController *)ctrl didSelectedType:(NSString *)type;

@end

@interface SendTypeListViewController : UITableViewController
{
    NSMutableArray *buffer;
    id<SendTypeListViewControllerDelegate>delegate;
}

@property(nonatomic,retain)id<SendTypeListViewControllerDelegate>delegate;
@end
