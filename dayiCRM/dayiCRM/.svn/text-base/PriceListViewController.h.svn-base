//
//  PriceListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-4.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceListViewController;

@protocol PriceListViewControllerDelegate <NSObject>

- (void)priceListViewController:(PriceListViewController*)ctrl didSeletedPrice:(NSString *)price;

@end

@interface PriceListViewController : UITableViewController
{
    __weak id<PriceListViewControllerDelegate>delegate;
    NSDictionary *dic;
}

@property(nonatomic,weak)id<PriceListViewControllerDelegate>delegate;
@property(nonatomic,retain)NSDictionary *dic;


@end
