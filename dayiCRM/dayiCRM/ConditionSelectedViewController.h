//
//  ConditionSelectedViewController.h
//  dayiCRM
//
//  Created by Fang on 14-10-13.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConditionSelectedViewControllerDelegate <NSObject>

- (void)conditionDidSelectedIndex:(NSUInteger)index;

@end

@interface ConditionSelectedViewController : UITableViewController
{
    NSArray *buffer;
    NSString *titleName;
   __weak id<ConditionSelectedViewControllerDelegate>delegate;
}

@property(nonatomic,weak)id<ConditionSelectedViewControllerDelegate>delegate;
@property(nonatomic,copy)NSString *titleName;

- (void)setUpBuffer:(NSArray *)arrar;

@end
