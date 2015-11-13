//
//  ProductListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-3.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductListViewController;

@protocol ProductListViewControllerDelegate <NSObject>

- (void)productListViewController:(ProductListViewController *)ctrl didSelectedProduct:(NSDictionary *)product;

@end

@interface ProductListViewController : UITableViewController
{
    __weak id <ProductListViewControllerDelegate>delegate;
    NSMutableArray *buffer;
    NSMutableArray *subBuffer;
	NSMutableArray *nodes;
	NSMutableArray *nodesTmpArray;
    BOOL isStockCheck;
    UIButton *btn1;
    UIButton *btn2;
    BOOL is_confirmed;
    NSString *zeroType;
    NSString *reportId;


}

@property(nonatomic,weak)id <ProductListViewControllerDelegate>delegate;
@property(nonatomic,assign)BOOL isStockCheck;
@property(nonatomic,copy)NSString *zeroType;
@property(nonatomic,copy)NSString *reportId;

@end
