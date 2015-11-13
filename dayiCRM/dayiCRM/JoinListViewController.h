//
//  JoinListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinListViewController : UITableViewController
{
    NSMutableArray *buffer;
}

- (void)setUpBuffer:(NSArray *)arrary;

@end
