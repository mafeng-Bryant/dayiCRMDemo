//
//  AppDelegate.m
//  dayiCRM
//
//  Created by Fang on 14-4-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AppDelegate.h"
#import "MsgListViewController.h"
#import "MemberListViewController.h"
#import "OrderListViewController.h"
#import "RRToken.h"
#import "FLViewController.h"
#import "OrderDetailViewController.h"
#import "StockTreeViewController.h"
#import "ManageListViewController.h"
#import "ProfileViewController.h"

NSString *pushStatus ()
{
	return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
	@"Notifications were active for this application" :
	@"Remote notifications were not active for this application";
}

static AppDelegate *instance = nil;

@implementation AppDelegate

+ (AppDelegate *) getInstance
{
    return instance;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
    
    if ([[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"])
    {
       aps = [NSDictionary dictionaryWithDictionary:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
        NSLog(@"%@",aps);
    }

    instance = self;

    [self customizeInterface];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if (![RRToken check]) {
        LoginViewController *ctrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        ctrl.delegate = self;
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];

    }
    else{
        [self didLogin];
    }
    
    return YES;
}

- (void) confirmationWasHidden: (NSNotification *) notification
{
    if(IOS8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge                                                                                         |UIRemoteNotificationTypeSound                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken length])
    {
        return;
    }
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"-- -- -- %@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
    NSLog(@"Error in registration. Error: %@", error);
    NSLog(@"%@",status);
    
}

// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    aps = userInfo;
    NSLog(@"----- -%@",aps);
    if (application.applicationState == UIApplicationStateInactive) {
        [self showDetail];
    }
    else if (application.applicationState == UIApplicationStateActive){
        if ([[aps objectForKey:@"msgType"] isEqualToString:@"talk"]) {
            MsgListViewController *ctrl = [self getSubController:RW_CATEGORY_MSG];
            [ctrl loadData];
        }
        else if ([[aps objectForKey:@"msgType"] isEqualToString:@"order"])
        {
            OrderListViewController *ctrl = [self getSubController:RW_CATEGORY_ORDER];
            [ctrl loadData];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self confirmationWasHidden:nil];
#endif
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeTabBarForController:(UITabBarController *)tabBarController {
    
    MsgListViewController *ctrl1 = [[MsgListViewController alloc] initWithNibName:@"MsgListViewController" bundle:nil];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:ctrl1];
    
    MemberListViewController *ctrl2 = [[MemberListViewController alloc] initWithNibName:@"MemberListViewController" bundle:nil];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:ctrl2];
    
//    OrderListViewController *ctrl3 = [[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ManageListViewController *ctrl3 = [[ManageListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:ctrl3];
    
//    StockTreeViewController *ctrl4 = [[StockTreeViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    ProfileViewController *ctrl4 = [[ProfileViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:ctrl4];
    
    [tabBarController setViewControllers:@[navigationController1,navigationController2,navigationController3,navigationController4] animated:NO];
    
    tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    tabBarController.tabBar.selectedImageTintColor = dayiColor;
    tabBarController.delegate = self;
    if (!IOS7) {
        [self setNoHighlightTabBar:tabBarController];
    }

}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_tall"]
                                      forBarMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar"]
                                      forBarMetrics:UIBarMetricsDefault];
    }
    NSDictionary *textAttributes = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
        
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    [[UITabBarItem appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor darkGrayColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12],UITextAttributeFont, nil] forState:UIControlStateNormal];//设置tabbar文字未选中状态下的颜色
    
    [[UITabBarItem appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: dayiColor,UITextAttributeTextColor,[UIFont systemFontOfSize:12],UITextAttributeFont, nil] forState:UIControlStateSelected];//设置tabbar文字选中状态下的颜色
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (!IOS7) {
        [self setNoHighlightTabBar:tabBarController];
    }
}

- (void)setNoHighlightTabBar:(UITabBarController *)tabBarController
{
    NSArray * tabBarSubviews = [tabBarController.tabBar subviews];
    
    int index4SelView;
    
    if(tabBarController.selectedIndex+1 > 4)
    {//selected the last tab.
        index4SelView = [tabBarSubviews count]-1;
        
    }
    else if([tabBarController.viewControllers count] > 5)
    {//have "more" tab. and havn't selected the last tab:"more" tab.
        
        index4SelView = [tabBarSubviews count] - 5 + tabBarController.selectedIndex;
    }
    else
    {//have no "more" tab.
        index4SelView = [tabBarSubviews count] -
        
        [tabBarController.viewControllers count] + tabBarController.selectedIndex;
    }
    if([tabBarSubviews count] < index4SelView+1)
    {
        assert(false);
        
        return;
    }
    
    UIView * selView = [tabBarSubviews objectAtIndex:index4SelView];
    
    NSArray * selViewSubviews = [selView subviews];
    
    for(UIView * v in selViewSubviews)
    {
        if(v && [NSStringFromClass([v class]) isEqualToString:@"UITabBarSelectionIndicatorView"])
        {//the v is the highlight view.
            [v removeFromSuperview];
            break;
        }
    }
}

- (void)didLogin
{
    TabBarController = [[UITabBarController alloc] init];
    TabBarController.delegate = self;
    
    [self customizeTabBarForController:TabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = TabBarController;
    [self.window makeKeyAndVisible];
    
    if([aps count])
    {
        [self showDetail];
    }
}

- (void) showDetail
{
    UINavigationController *nav_ctrl;
    nav_ctrl = [self getNavController:TabBarController.selectedIndex];
    
    if ([[aps objectForKey:@"msgType"] isEqualToString:@"talk"])
    {
        NSString *alert =[[aps objectForKey:@"aps"] objectForKey:@"alert"];
        NSArray *array = [alert componentsSeparatedByString:@":"];
        
        FLViewController *ctrl = [[FLViewController alloc] initWithNibName:@"FLViewController" bundle:nil];
        ctrl.title = [array objectAtIndex:0];
        ctrl.userId = [aps objectForKey:@"userId"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [nav_ctrl pushViewController:ctrl animated:YES];
        if ([nav_ctrl respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            nav_ctrl.interactivePopGestureRecognizer.delegate = nil;
        }

    }
    else if ([[aps objectForKey:@"msgType"] isEqualToString:@"order"])
    {
        OrderDetailViewController *ctrl = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        ctrl.oid = [aps objectForKey:@"sourceId"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [nav_ctrl pushViewController:ctrl animated:YES];
        if ([nav_ctrl respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            nav_ctrl.interactivePopGestureRecognizer.delegate = nil;
        }

    }
}

- (id) getNavController: (NSInteger)forCategory
{
	return [TabBarController.viewControllers objectAtIndex:forCategory];
}

- (id) getSubController: (NSInteger)forCategory
{
	return [[[self getNavController:forCategory] viewControllers] objectAtIndex:0];
}

- (void)checkToken
{
    UINavigationController *nav_ctrl;
	nav_ctrl = [self getNavController:TabBarController.selectedIndex];
    if (![RRToken check]) {
        LoginViewController *ctrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        nav.navigationBarHidden = YES;
        [nav_ctrl presentViewController:nav animated:YES completion:nil];
     }
}


@end
