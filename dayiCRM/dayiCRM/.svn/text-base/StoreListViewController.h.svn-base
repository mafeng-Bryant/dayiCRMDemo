//
//  StoreListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-5-27.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreListViewControllerDelegate<NSObject>
- (void)didSelectedStoreName:(NSString *)name;
@end

@interface StoreListViewController : UITableViewController
{
    NSMutableArray *buffer;
    __weak id <StoreListViewControllerDelegate>delegate;
    
}

@property (nonatomic,weak)id <StoreListViewControllerDelegate>delegate;
@property (nonatomic,copy)NSMutableArray *buffer;
@end
