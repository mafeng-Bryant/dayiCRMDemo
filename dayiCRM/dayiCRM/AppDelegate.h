//
//  AppDelegate.h
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
enum RW_CATEGORY {
	RW_CATEGORY_MSG = 0,
	RW_CATEGORY_MEMBER,
	RW_CATEGORY_ORDER,
	RW_CATEGORY_STOCK,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,LoginViewDelegate>
{
    UITabBarController *TabBarController;
    NSDictionary *aps;
}

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *) getInstance;

- (void)checkToken;

@end

