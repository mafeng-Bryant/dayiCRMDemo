//
//  CompareViewController.h
//  dayiCRM
//
//  Created by Fang on 14-5-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareViewController : UIViewController<UITextFieldDelegate>
{
    NSString *tel;
    NSTimer *timer;
    NSUInteger count;
    NSString *randNumber;
}

@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *randNumber;

@end
