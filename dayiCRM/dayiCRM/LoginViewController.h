//
//  LoginViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional

- (void)didLogin;

@end


@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    id <LoginViewDelegate>delegate;
}

@property(nonatomic,retain)id <LoginViewDelegate>delegate;

@end
