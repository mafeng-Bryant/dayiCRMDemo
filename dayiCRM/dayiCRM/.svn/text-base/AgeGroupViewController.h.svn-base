//
//  AgeGroupViewController.h
//  dayiCRM
//
//  Created by Fang on 14-5-27.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgeGroupViewControllerDelegate <NSObject>

- (void)ageGroupDidSelected:(NSString *)index;

@end
@interface AgeGroupViewController : UITableViewController
{
    __weak id<AgeGroupViewControllerDelegate>delegate;
    NSString *ageGroup;
}

@property(nonatomic,weak)id<AgeGroupViewControllerDelegate>delegate;
@property(nonatomic,copy)NSString *ageGroup;

@end
